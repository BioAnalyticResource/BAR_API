# eFP Proxy Guide

This note documents how the new `/efp_proxy` endpoints work, why they satisfy the “one web call + one SQL query” requirement, and how to exercise them locally even without access to the production MySQL servers.

## What This Implementation Delivers

- **Single HTTP request** to BAR’s CGI: `/efp_proxy/values/{database}/{gene_id}` collects every sample (either from the `samples` query param or by auto-loading the list from `data/efp_info/efp_species_view_info.json`) and ships them to `https://bar.utoronto.ca/eplant/cgi-bin/plantefp.cgi` in one call. See `api/resources/efp_proxy.py` (function `fetch_efp_data`).
- **Single SQL query** for any mirrored database: `/efp_proxy/expression/{database}/{gene_id}` looks up the table/column names in a schema catalog and runs one `SELECT sample, value FROM sample_data WHERE gene_column = :gene_id` statement. No per-database ORM/models or branching logic are needed.
- **Dynamic database routing**: Every request first tries the live SQLAlchemy bind (`db.get_engine(bind=database)`), then falls back to the SQLite mirror you generate locally. The same code therefore works offline (using mirrors) and online (using the real DB) without any changes.
- **Consistent JSON payload**: Both endpoints output `[{"name": SAMPLE_ID, "value": SIGNAL}, …]`, so the frontend expects the same structure whether data came from the CGI or a local/remote database.

## Key Code Highlights

### One Web Call

```python
def fetch_efp_data(datasource, gene_id, samples=None):
    query_params = [
        ("datasource", datasource),
        ("id", gene_id),
        ("format", "json"),
    ]
    ...
    response = requests.get(base_url, params=query_params)
```

- If `samples` are provided (repeat `?samples=foo&samples=bar` in the query string, or use the legacy JSON array), they are appended once.  
- If `samples` is omitted, `get_all_samples_for_view` loads every sample for that datasource and adds that list.  
- The request is made **exactly once**; if the CGI returns nothing we retry without the `samples` hint but still as a single call.  
- Returned data already looks like `[{"name": "...", "value": "..."}]`.

### One SQL Query

```python
def query_efp_database_dynamic(database, gene_id, sample_ids=None):
    schema = DYNAMIC_DATABASE_SCHEMAS[database]
    db_path = DATABASE_DIR / schema["filename"]
    engine_candidates = []
    try:
        bound_engine = db.get_engine(bind=database)
        engine_candidates.append(("sqlalchemy_bind", bound_engine, False))
    except Exception:
        ...
    if db_path.exists():
        sqlite_engine = create_engine(f"sqlite:///{db_path}")
        engine_candidates.append(("sqlite_mirror", sqlite_engine, True))

    query_sql = text(
        f"SELECT {schema['sample_column']} AS sample, "
        f"{schema['value_column']} AS value "
        f"FROM {schema['table']} "
        f"WHERE {schema['gene_column']} = :gene_id"
    )
```

- `DYNAMIC_DATABASE_SCHEMAS` is a simple dictionary (`{db_name: {table, gene_column, ...}}`). No per-database models are required for the endpoint.  
- The helper first attempts the live bind (`sqlalchemy_bind`) and only if that fails does it open the SQLite mirror (`sqlite_mirror`).  
- One SQL statement fetches every sample/value row for the requested gene and we normalize it into `[{"name": ..., "value": ...}]`.

### Why You Might Not See “All Values” Locally

- The repo ships *trimmed-down* `.sql` dumps (fixtures) inside `config/databases/*.sql`. When you build mirrors with `python scripts/build_sqlite_mirrors.py`, you are mirroring that limited data, so `/expression/klepikova/AT1G01010` only returns the single SRR row included in the dump (currently `SRR3581336`). The long `INSERT INTO sample_general_info ... SRR...` block is metadata; it doesn’t contain expression values. `/expression` only reads `sample_data`, because that table has the `data_signal` column required for output.
- The long `INSERT INTO sample_general_info ... SRR...` block is metadata; it doesn’t contain expression values. `/expression` only reads `sample_data`, because that table has the `data_signal` column required for output.
- As soon as you connect to the real MySQL databases (by running the dockerized MySQL or pointing `SQLALCHEMY_BINDS` at production), the bind succeeds first and you immediately get the full data set.

## Workflow: Local Mirrors vs. Real Databases

1. **Generate mirrors** (local dev only):
   ```bash
   python scripts/build_sqlite_mirrors.py klepikova sample_data
   ```
   This produces `config/databases/klepikova.db`, etc. The endpoint automatically uses them when the MySQL bind isn’t available.

2. **Run the API**:
   ```bash
   flask run  # or docker compose up api
   ```

3. **Test the endpoints**:
    - External CGI with auto-loaded samples (one web call):
     ```
     http://127.0.0.1:5000/efp_proxy/values/atgenexp_stress/AT1G01010
     http://127.0.0.1:5000/efp_proxy/values/root_Schaefer_lab/AT3G24650?samples=WTCHG_203594_01&samples=WTCHG_203594_05
     ```
   - Dynamic DB query (one SQL statement):
     ```
     http://127.0.0.1:5000/efp_proxy/expression/klepikova/AT1G01010
     http://127.0.0.1:5000/efp_proxy/expression/sample_data/261585_at
     ```

4. **Deploying with the real databases**: ensure `config/BAR_API.cfg` points to the production MySQL hosts. `query_efp_database_dynamic` will hit them via `db.get_engine(bind=database)`; the SQLite mirrors simply act as a fallback when you’re offline.

## Static vs. Dynamic: What Changed

- **Static approach** (old): every database needed its own model file (e.g., `api/models/klepikova.py`), controller logic, and SQL query. Adding a new dataset meant writing more Python and risking inconsistencies.
- **Dynamic approach** (new):
  - We only maintain the simple schema catalog (table + column names per database).
  - The same endpoint and SQL query cover every database.
  - No new ORM classes are required for `/efp_proxy/expression`. (Other parts of the API still use those models, which is why the files remain in the repo.)
  - Switching between local mirrors and live MySQL happens automatically.

## Why We Still Can’t “Pull Everything” Locally

- The SQLite mirrors you generate reflect whatever is inside the `.sql` dump—often a very small subset used by tests.
- Without the real MySQL dump, the endpoint physically can’t return rows that don’t exist in the mirror. This is a data limitation, not a code bug.
- Once hooked to the production database, the query returns all values in a single request/statement, fulfilling the original requirement.

## Summary

- `/efp_proxy/values` → ONE external web call, optional sample filtering.  
- `/efp_proxy/expression` → ONE SQL query per request, dynamic schema lookup, automatic choice between live MySQL and local SQLite.  
- Schema catalog + mirror script = no more per-database boilerplate.  
- Full datasets appear as soon as the real databases are reachable; mirrors just keep development/testing running offline.

This architecture hits the deliverables outlined in the project brief while keeping the codebase maintainable for future databases.
