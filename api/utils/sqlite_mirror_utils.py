"""
Helpers for building local SQLite mirrors from MySQL dumps.

Used to make local tests work without a running MySQL instance.
"""

from __future__ import annotations

import re
import sqlite3
from pathlib import Path

# Regex helpers to strip MySQL-only clauses (storage engine, charset, auto-increment, etc.)
ENGINE_REGEX = re.compile(r"\)\s*ENGINE=.*;", flags=re.IGNORECASE)
CHARSET_REGEX = re.compile(r"DEFAULT\s+CHARSET=.*?(?=\)|;)", flags=re.IGNORECASE)
COLLATE_REGEX = re.compile(r"COLLATE\s*=\s*[^\s)]+", flags=re.IGNORECASE)
CHARACTER_SET_REGEX = re.compile(r"\s+CHARACTER SET\s+[^\s,]+", flags=re.IGNORECASE)
INLINE_COLLATE_REGEX = re.compile(r"\s+COLLATE\s+[^\s,]+", flags=re.IGNORECASE)
COLUMN_AUTO_INCREMENT_REGEX = re.compile(r"\s+AUTO_INCREMENT\b", flags=re.IGNORECASE)
AUTO_INCREMENT_REGEX = re.compile(r"AUTO_INCREMENT=\d+", flags=re.IGNORECASE)
ENUM_REGEX = re.compile(r"\benum\s*\([^)]*\)", flags=re.IGNORECASE)
SET_REGEX = re.compile(r"\bset\s*\([^)]*\)", flags=re.IGNORECASE)
COMMENT_SQ_REGEX = re.compile(r"\s+COMMENT\s+'[^']*'", flags=re.IGNORECASE)
COMMENT_DQ_REGEX = re.compile(r'\s+COMMENT\s+"[^"]*"', flags=re.IGNORECASE)
BTREE_REGEX = re.compile(r"\s+USING\s+BTREE", flags=re.IGNORECASE)


def sanitize_mysql_dump(sql_text: str) -> str:
    """Remove MySQL-only statements so SQLite can execute the script."""
    sanitized_lines: list[str] = []
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
        line = CHARACTER_SET_REGEX.sub("", line)
        line = INLINE_COLLATE_REGEX.sub("", line)
        line = ENUM_REGEX.sub("TEXT", line)
        line = SET_REGEX.sub("TEXT", line)
        line = COMMENT_SQ_REGEX.sub("", line)
        line = COMMENT_DQ_REGEX.sub("", line)
        line = BTREE_REGEX.sub("", line)
        line = AUTO_INCREMENT_REGEX.sub("", line)
        line = COLUMN_AUTO_INCREMENT_REGEX.sub("", line)

        sanitized_lines.append(line)

    sanitized = "\n".join(sanitized_lines)
    sanitized = re.sub(r",\s*\n\)", "\n)", sanitized)
    return sanitized


def build_sqlite_db(sql_path: Path, db_path: Path) -> None:
    """Create/overwrite SQLite DB from the provided MySQL dump."""
    sql_text = sql_path.read_text(encoding="utf-8")
    sanitized_sql = sanitize_mysql_dump(sql_text)
    if not sanitized_sql.strip():
        raise RuntimeError(f"No executable SQL found in {sql_path.name}")

    if db_path.exists():
        db_path.unlink()

    conn = sqlite3.connect(db_path)
    try:
        conn.executescript("PRAGMA foreign_keys = OFF;")
        conn.executescript(sanitized_sql)
        conn.commit()
    finally:
        conn.close()
