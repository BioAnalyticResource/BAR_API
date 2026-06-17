"""
Analyze eFP database structures to find the most compact schema representation.

Since we only need 3 columns (data_probeset_id, data_signal, data_bot_id),
this script groups databases by their column signatures to identify
shared patterns and enable a table-driven schema definition.

Usage:
    python api/Archive/analyze_efp_schemas.py
"""

import csv
from collections import defaultdict

STRUCTURE_CSV = "api/Archive/efp_tables_structure_sample_data_dump_01_28_25.csv"
SAMPLE_DATA_CSV = "api/Archive/sample_data_export_feb_4.csv"

# Only these 3 columns matter for the API
NEEDED_COLUMNS = {"data_probeset_id", "data_signal", "data_bot_id"}

# Extra columns that some databases have (we want to know which ones)
EXTRA_COLUMNS = {
    "channel",
    "data_call",
    "data_num",
    "data_p_val",
    "data_p_value",
    "genome",
    "genome_id",
    "log",
    "orthogroup",
    "p_val",
    "project_id",
    "qvalue",
    "sample_file_name",
    "sample_tissue",
    "version",
}


def parse_structure_csv():
    """Parse the structure CSV into per-database column definitions."""
    db_columns = defaultdict(dict)  # {db_name: {col_name: {type, nullable, default}}}

    with open(STRUCTURE_CSV, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            db = row["database_name"]
            col = row["COLUMN_NAME"]
            db_columns[db][col] = {
                "type": row["COLUMN_TYPE"],
                "nullable": row["IS_NULLABLE"] == "YES",
                "default": row["COLUMN_DEFAULT"],
            }
    return db_columns


def extract_signature(db_cols):
    """
    Extract a signature tuple for the 3 needed columns.
    Returns (probeset_type, probeset_nullable, signal_nullable, signal_default, bot_type, bot_nullable)
    """
    p = db_cols.get("data_probeset_id", {})
    s = db_cols.get("data_signal", {})
    b = db_cols.get("data_bot_id", {})
    return (
        p.get("type", "?"),
        p.get("nullable", False),
        s.get("nullable", False),
        s.get("default", "NULL"),
        b.get("type", "?"),
        b.get("nullable", False),
    )


def parse_varchar_length(col_type):
    """Extract length from varchar(N) or return None for tinytext/text."""
    if col_type.startswith("varchar("):
        return int(col_type[8:-1])
    return None  # tinytext, text, etc.


def main():
    db_columns = parse_structure_csv()

    print("=" * 80)
    print("EFP SCHEMA ANALYSIS - Only 3 columns needed")
    print("=" * 80)
    print(f"\nTotal databases: {len(db_columns)}")
    print(f"Needed columns: {', '.join(sorted(NEEDED_COLUMNS))}")

    # ---- 1. Check which databases have extra columns beyond the 3 ----
    print("\n" + "=" * 80)
    print("DATABASES WITH EXTRA COLUMNS (beyond the 3 needed + proj_id + sample_id)")
    print("=" * 80)
    dbs_with_extras = {}
    for db, cols in sorted(db_columns.items()):
        extras = set(cols.keys()) - NEEDED_COLUMNS - {"proj_id", "sample_id"}
        if extras:
            dbs_with_extras[db] = extras
            print(f"  {db}: {', '.join(sorted(extras))}")

    dbs_simple = set(db_columns.keys()) - set(dbs_with_extras.keys())
    print(f"\n  -> {len(dbs_simple)} databases have ONLY the 5 standard columns")
    print(f"  -> {len(dbs_with_extras)} databases have extra columns")

    # ---- 2. Group databases by their 3-column signature ----
    print("\n" + "=" * 80)
    print(
        "GROUPING BY SIGNATURE (probeset_type, probeset_nullable, signal_nullable, signal_default, bot_type, bot_nullable)"
    )
    print("=" * 80)

    sig_groups = defaultdict(list)
    for db, cols in sorted(db_columns.items()):
        sig = extract_signature(cols)
        sig_groups[sig].append(db)

    for sig, dbs in sorted(sig_groups.items(), key=lambda x: -len(x[1])):
        print(
            f"\n  Signature: probeset={sig[0]}(nullable={sig[1]}) signal(nullable={sig[2]}, default={sig[3]}) bot={sig[4]}(nullable={sig[5]})"
        )
        print(f"  Count: {len(dbs)}")
        print(f"  DBs: {', '.join(dbs[:10])}{'...' if len(dbs) > 10 else ''}")

    # ---- 3. Group by (probeset_len, bot_len) - the key variable dimensions ----
    print("\n" + "=" * 80)
    print("DATA-DRIVEN COMPACT FORMAT: Group by (probeset_type, bot_type)")
    print("Only considering the 3 needed columns")
    print("=" * 80)

    # For the compact representation, what varies per database is:
    # - data_probeset_id: type (varchar(N) or tinytext) and length
    # - data_bot_id: type (varchar(N) or tinytext) and length
    # - data_signal: nullable and default (always float)
    # We can represent this as a tuple per database

    compact_entries = []
    for db, cols in sorted(db_columns.items()):
        p = cols.get("data_probeset_id", {})
        s = cols.get("data_signal", {})
        b = cols.get("data_bot_id", {})

        probeset_type = p.get("type", "varchar(24)")
        bot_type = b.get("type", "varchar(16)")
        signal_nullable = s.get("nullable", False)

        probeset_len = parse_varchar_length(probeset_type)
        bot_len = parse_varchar_length(bot_type)

        # Determine extra columns this DB needs
        extras = set(cols.keys()) - NEEDED_COLUMNS - {"proj_id", "sample_id"}

        compact_entries.append(
            {
                "db": db,
                "probeset_len": probeset_len,  # None = tinytext
                "probeset_type": probeset_type,
                "bot_len": bot_len,  # None = tinytext
                "bot_type": bot_type,
                "signal_nullable": signal_nullable,
                "extras": extras,
            }
        )

    # ---- 4. Show the most compact table-driven representation ----
    print("\n" + "=" * 80)
    print("PROPOSED COMPACT TUPLE FORMAT")
    print("Each DB needs: (name, probeset_len_or_None, bot_len_or_None, signal_nullable)")
    print("None = tinytext (TEXT in our schema)")
    print("=" * 80)

    # Group by shared properties to find patterns
    pattern_groups = defaultdict(list)
    for e in compact_entries:
        key = (e["probeset_len"], e["bot_len"], e["signal_nullable"], tuple(sorted(e["extras"])))
        pattern_groups[key].append(e["db"])

    print(f"\nUnique (probeset_len, bot_len, signal_nullable, extras) combinations: {len(pattern_groups)}")
    print("\nTop patterns (most databases sharing the same column spec):")
    for (pl, bl, sn, ex), dbs in sorted(pattern_groups.items(), key=lambda x: -len(x[1]))[:20]:
        extras_str = f", extras={list(ex)}" if ex else ""
        print(f"  probeset={pl}, bot={bl}, signal_nullable={sn}{extras_str}")
        print(f"    Count: {len(dbs)}, DBs: {', '.join(dbs[:5])}{'...' if len(dbs) > 5 else ''}")

    # ---- 5. Generate the most compact code ----
    print("\n" + "=" * 80)
    print("GENERATED COMPACT TABLE (for efp_schemas.py)")
    print("Format: (db_name, probeset_len, bot_len)")
    print("  - probeset_len: int for varchar(N), 0 for tinytext")
    print("  - bot_len: int for varchar(N), 0 for tinytext")
    print("  - signal is always float, nullable is always True (safe default)")
    print("=" * 80)

    # Simple databases (only 3 needed columns, no extras of concern)
    simple_dbs = []
    complex_dbs = []
    for e in compact_entries:
        # Filter out databases that ONLY have unneeded extras
        # (sample_file_name, data_call, data_p_val etc. are not needed)
        has_important_extras = e["extras"] - {"sample_file_name", "data_call", "data_p_val", "data_p_value", "data_num"}
        if has_important_extras:
            complex_dbs.append(e)
        else:
            simple_dbs.append(e)

    print(f"\nSimple databases (only need 3 columns): {len(simple_dbs)}")
    print(f"Complex databases (have unique extra columns): {len(complex_dbs)}")

    print("\n# ---- SIMPLE DATABASES (table-driven) ----")
    print("# (db_name, probeset_len, bot_len)")
    print("# probeset_len/bot_len: positive int = varchar(N), 0 = tinytext")
    print("_SIMPLE_EFP_SPECS = [")
    for e in sorted(simple_dbs, key=lambda x: x["db"]):
        pl = e["probeset_len"] if e["probeset_len"] is not None else 0
        bl = e["bot_len"] if e["bot_len"] is not None else 0
        print(f'    ("{e["db"]}", {pl}, {bl}),')
    print("]")

    print(f"\n# ---- COMPLEX DATABASES (need manual definition) ----")
    for e in sorted(complex_dbs, key=lambda x: x["db"]):
        pl = e["probeset_len"] if e["probeset_len"] is not None else "tinytext"
        bl = e["bot_len"] if e["bot_len"] is not None else "tinytext"
        print(f'# {e["db"]}: probeset={pl}, bot={bl}, extras={sorted(e["extras"])}')

    # ---- 6. Analyze sample data for testing ----
    print("\n" + "=" * 80)
    print("SAMPLE DATA SUMMARY (for test verification)")
    print("=" * 80)

    try:
        db_samples = defaultdict(list)
        with open(SAMPLE_DATA_CSV, newline="") as f:
            reader = csv.DictReader(f)
            for row in reader:
                db_samples[row["source_database"]].append(
                    {
                        "data_bot_id": row["data_bot_id"],
                        "data_probeset_id": row["data_probeset_id"],
                        "data_signal": row["data_signal"],
                    }
                )

        print(f"Total databases with sample data: {len(db_samples)}")
        print(f"Total sample rows: {sum(len(v) for v in db_samples.values())}")

        # Verify sample data matches structure
        for db in sorted(db_samples.keys()):
            if db not in db_columns:
                print(f"  WARNING: {db} has sample data but no structure definition!")
        for db in sorted(db_columns.keys()):
            if db not in db_samples:
                print(f"  WARNING: {db} has structure but no sample data!")

    except FileNotFoundError:
        print("  Sample data file not found, skipping.")

    # ---- 7. Final recommendation ----
    print("\n" + "=" * 80)
    print("RECOMMENDATION")
    print("=" * 80)
    print(f"""
Since you only need 3 columns (data_probeset_id, data_signal, data_bot_id),
the entire schema can be reduced to a simple lookup table.

Current efp_schemas.py: ~1984 lines
Proposed compact version: ~{len(simple_dbs) + 50} lines (table + builder)

Each database only differs in:
  1. data_probeset_id length (varchar(N) or tinytext)
  2. data_bot_id length (varchar(N) or tinytext)

data_signal is always float.

The compact format uses a list of tuples:
  (db_name, probeset_len, bot_len)

A single builder function converts these tuples into full schema dicts.

Complex databases ({len(complex_dbs)}) that have unique extra columns
(channel, genome, genome_id, orthogroup, version, log, p_val, qvalue,
sample_tissue) need individual definitions.
""")


if __name__ == "__main__":
    main()
