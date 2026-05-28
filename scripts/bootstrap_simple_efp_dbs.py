#!/usr/bin/env python3
"""
Reena Obmina | BCB330 Project 2025-2026 | University of Toronto

CLI script to create all eFP MySQL databases from the shared schema registry.

Usage:
    python scripts/bootstrap_simple_efp_dbs.py
    python scripts/bootstrap_simple_efp_dbs.py --databases embryo klepikova
    python scripts/bootstrap_simple_efp_dbs.py --host localhost --port 3306
"""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

from sqlalchemy.exc import SQLAlchemyError

# Ensure the repository root is importable when this script is executed standalone
ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from api.services.efp_bootstrap import bootstrap_simple_efp_databases  # noqa: E402


def _default_host() -> str:
    """Resolve the default MySQL hostname from environment variables.

    Checks DB_HOST, then MYSQL_HOST, then falls back to 'localhost'.
    Docker deployments should set DB_HOST=BAR_mysqldb explicitly.

    :returns: MySQL hostname string.
    :rtype: str
    """
    if os.environ.get("DB_HOST"):
        return os.environ["DB_HOST"]
    if os.environ.get("MYSQL_HOST"):
        return os.environ["MYSQL_HOST"]
    return "localhost"


def parse_args() -> argparse.Namespace:
    """Parse command-line arguments for the bootstrap script.

    :returns: Parsed arguments with host, port, user, password, and optional database list.
    :rtype: argparse.Namespace
    """
    parser = argparse.ArgumentParser(description="Create simple eFP MySQL databases from in-memory schemas.")
    parser.add_argument("--host", default=_default_host(), help="MySQL hostname (default: %(default)s)")
    parser.add_argument("--port", type=int, default=int(os.environ.get("DB_PORT", 3306)), help="MySQL port")
    parser.add_argument("--user", default=os.environ.get("DB_USER", "root"), help="MySQL user")
    parser.add_argument("--password", default=os.environ.get("DB_PASS", "root"), help="MySQL password")
    parser.add_argument(
        "--databases",
        nargs="*",
        help="Optional list of databases to bootstrap (defaults to every simple schema).",
    )
    return parser.parse_args()


def main():
    """Run the bootstrap CLI — creates all eFP databases and prints a result per entry.

    Output format: [ok] ensured database_name.table_name (seeded N rows)

    :raises SQLAlchemyError: If database creation or connection fails.
    """
    args = parse_args()
    results = bootstrap_simple_efp_databases(
        host=args.host,
        port=args.port,
        user=args.user,
        password=args.password,
        databases=args.databases,
    )
    for entry in results:
        seeded = entry["seeded_rows"]
        seed_msg = f"seeded {seeded} rows" if seeded else "no seed rows inserted"
        print(f"[ok] ensured {entry['database']}.{entry['table']} ({seed_msg})")


if __name__ == "__main__":
    try:
        main()
    except SQLAlchemyError as exc:
        print(f"failed to initialize simple efp databases: {exc}")
        raise
