#!/usr/bin/env python3
"""
bootstrap the simple efp databases from the shared schema definitions
"""

from __future__ import annotations

import argparse
import os

from sqlalchemy.exc import SQLAlchemyError

from api.services.efp_bootstrap import bootstrap_simple_efp_databases


def _default_host() -> str:
    if os.environ.get("DB_HOST"):
        return os.environ["DB_HOST"]
    if os.environ.get("MYSQL_HOST"):
        return os.environ["MYSQL_HOST"]
    # GitHub Actions CI uses localhost; Docker Compose uses bar_mysqldb
    # CI env var is set in GitHub Actions, but not DB_HOST
    # In Docker, DB_HOST should be explicitly set to BAR_mysqldb
    return "localhost"


def parse_args() -> argparse.Namespace:
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
        # match init.sh style output to keep ci logs readable
        print(f"failed to initialize simple efp databases: {exc}")
        raise
