# Dynamic ORM - Simple Guide

## File Roles

### `api/models/efp_schemas.py`
Defines database schemas in Python. Single source of truth for all columns, types, and test data.

### `api/models/efp_dynamic.py`
Reads schemas and auto-generates SQLAlchemy ORM model classes at import time. No model files needed.

### `api/services/efp_bootstrap.py`
Creates MySQL databases and tables from schemas. Inserts seed data for testing.

### `scripts/bootstrap_simple_efp_dbs.py`
CLI tool to run the bootstrap. Usage: `python scripts/bootstrap_simple_efp_dbs.py --databases cannabis`

### `api/services/efp_data.py`
Query engine. Tries MySQL first (production), falls back to SQLite (local dev).

## Test Locally

### With MySQL:
```bash
# Create databases
python scripts/bootstrap_simple_efp_dbs.py --user root --password root

# Run tests
pytest tests/services/test_efp_data.py -v
```

### With SQLite:
```bash
# Just run tests - will use SQLite files in config/databases/
pytest tests/services/test_efp_data.py -v
```

## How It Works on Server

1. Docker starts → runs `config/init.sh`
2. `init.sh` runs bootstrap script
3. Bootstrap creates MySQL databases from schemas
4. Flask app connects to MySQL via SQLAlchemy binds
5. Queries use `db.engines.get("cannabis")` to get MySQL connection

## Summary

**Before:** Write .sql files + Python models manually
**Now:** Define schema once in Python → everything auto-generated
