#!/usr/bin/env python3
"""
Utility to convert the shipped MySQL dumps under config/databases into local
SQLite mirrors that api.resources.efp_proxy can read without a live MySQL bind.

Usage:
    python scripts/build_sqlite_mirrors.py               # build every mirror
    python scripts/build_sqlite_mirrors.py klepikova     # build selected DBs
    python scripts/build_sqlite_mirrors.py --force ...   # overwrite .db files
"""

from __future__ import annotations

import argparse
import re
import sqlite3
import sys
from pathlib import Path
from typing import Iterable


ROOT_DIR = Path(__file__).resolve().parents[1]
DATABASE_DIR = ROOT_DIR / "config" / "databases"

# Regex helpers to strip MySQL-only clauses (storage engine, charset, auto-increment, etc.)
# so the CREATE TABLE statements can be executed by SQLite without syntax errors.
ENGINE_REGEX = re.compile(r"\)\s*ENGINE=.*;", flags=re.IGNORECASE)
CHARSET_REGEX = re.compile(r"DEFAULT\s+CHARSET=.*?(?=\)|;)", flags=re.IGNORECASE)
COLLATE_REGEX = re.compile(r"COLLATE\s*=\s*[^\s)]+", flags=re.IGNORECASE)
COLUMN_AUTO_INCREMENT_REGEX = re.compile(r"\s+AUTO_INCREMENT\b", flags=re.IGNORECASE)
AUTO_INCREMENT_REGEX = re.compile(r"AUTO_INCREMENT=\d+", flags=re.IGNORECASE)


def discover_sql_files() -> dict[str, Path]:
    """Return a map of database name -> dump path (stem of filename)."""
    sql_files = {}
    for path in DATABASE_DIR.glob("*.sql"):
        sql_files[path.stem] = path
    return sql_files


def sanitize_mysql_dump(sql_text: str) -> str:
    """Remove MySQL-only statements so SQLite can execute the script."""
    sanitized_lines = []
    skip_block = False

    for line in sql_text.splitlines():
        if skip_block:
            if ";" in line:
                skip_block = False
            continue

        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith("--"):
            continue

        upper = stripped.upper()
        if upper.startswith("LOCK TABLES") or upper.startswith("UNLOCK TABLES"):
            continue
        if upper.startswith("CREATE DATABASE") or upper.startswith("USE "):
            continue
        if upper.startswith("SET ") or upper.startswith("DELIMITER "):
            continue
        if upper.startswith("START TRANSACTION") or upper == "COMMIT;":
            continue
        if upper.startswith("ALTER TABLE "):
            skip_block = True
            continue
        if upper.startswith("KEY ") or upper.startswith("UNIQUE KEY") or upper.startswith("FULLTEXT KEY"):
            continue
        if stripped.startswith("/*!"):
            # Skip MySQL conditional comments entirely.
            continue

        line = ENGINE_REGEX.sub(");", line)
        line = CHARSET_REGEX.sub("", line)
        line = COLLATE_REGEX.sub("", line)
        line = AUTO_INCREMENT_REGEX.sub("", line)
        line = COLUMN_AUTO_INCREMENT_REGEX.sub("", line)

        sanitized_lines.append(line)

    sanitized = "\n".join(sanitized_lines)
    sanitized = re.sub(r",\s*\n\)", "\n)", sanitized)
    return sanitized


def build_sqlite_db(sql_path: Path, db_path: Path, force: bool) -> None:
    """Create/overwrite SQLite DB from the provided MySQL dump."""
    if db_path.exists():
        if not force:
            print(f"[skip] {db_path.name} already exists (use --force to overwrite)")
            return
        db_path.unlink()

    sql_text = sql_path.read_text(encoding="utf-8")
    # SQLite cannot run raw MySQL dumps, so we strip dialect-specific bits first.
    sanitized_sql = sanitize_mysql_dump(sql_text)
    if not sanitized_sql.strip():
        raise RuntimeError(f"No executable SQL found in {sql_path.name}")

    conn = sqlite3.connect(db_path)
    try:
        # Disable FK constraints while replaying the dump to avoid dependency issues.
        conn.executescript("PRAGMA foreign_keys = OFF;")
        # Executescript lets us run the entire dump in one go.
        conn.executescript(sanitized_sql)
        conn.commit()
        print(f"[ok] Created {db_path.relative_to(ROOT_DIR)}")
    finally:
        conn.close()


def parse_args(argv: Iterable[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate SQLite mirrors from the MySQL dumps in config/databases",
    )
    parser.add_argument(
        "databases",
        nargs="*",
        help="Database names to convert (defaults to every *.sql file).",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite existing .db files instead of skipping them.",
    )
    return parser.parse_args(list(argv))


def main(argv: Iterable[str]) -> int:
    args = parse_args(argv)
    # Step 1: discover every *.sql dump shipped with the repo.
    # These dumps are the source of truth for the local mirrors.
    available = discover_sql_files()
    if not available:
        print("No .sql dumps found in config/databases", file=sys.stderr)
        return 1

    targets = args.databases or sorted(available.keys())
    missing = [name for name in targets if name not in available]
    if missing:
        print(f"Unknown database(s): {', '.join(missing)}", file=sys.stderr)
        print(f"Available dumps: {', '.join(sorted(available.keys()))}", file=sys.stderr)
        return 1

    # Step 2: iterate over each requested dump and build the matching SQLite db.
    for name in targets:
        sql_path = available[name]
        db_path = DATABASE_DIR / f"{name}.db"
        build_sqlite_db(sql_path, db_path, force=args.force)

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
