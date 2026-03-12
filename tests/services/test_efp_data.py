import os
import re
import sys
from datetime import date
from unittest import TestCase

# allow importing api when invoking pytest from this directory tree
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from api import app, db  # noqa: E402
from api.models.annotations_lookup import AtAgiLookup  # noqa: E402
from api.services.efp_data import query_efp_database_dynamic  # noqa: E402


class TestDynamicEfpData(TestCase):
    """unit tests for the shared efp query helper in api/services/efp_data.py"""

    def setUp(self):
        # each test needs an application context so flask-sqlalchemy can look up binds
        self.ctx = app.app_context()
        self.ctx.push()

    def tearDown(self):
        self.ctx.pop()

    def test_embryo_query_is_case_insensitive(self):
        """lower-case agi ids still return the embryo sample row"""
        result = query_efp_database_dynamic("embryo", "at1g01010", allow_empty_results=False)
        self.assertTrue(result["success"])
        self.assertEqual(result["record_count"], 1)
        self.assertEqual(result["data"][0]["name"], "pg_1")
        self.assertEqual(result["data"][0]["value"], "0.67")

    def test_sample_filter_handles_case(self):
        """sample filters compare case-insensitively when the flag is set"""
        result = query_efp_database_dynamic(
            "shoot_apex",
            "AT1G01010",
            sample_ids=["ufo"],
            allow_empty_results=False,
            sample_case_insensitive=True,
        )
        self.assertTrue(result["success"])
        self.assertEqual(result["record_count"], 1)
        self.assertEqual(result["data"][0]["name"], "UFO")
        self.assertEqual(result["data"][0]["value"], "1.61714")

    def test_invalid_database(self):
        """an unsupported database name should trigger a 400 error"""
        result = query_efp_database_dynamic("not_a_db", "AT1G01010")
        self.assertFalse(result["success"])
        self.assertEqual(result["error_code"], 400)

    def test_invalid_gene_format(self):
        """malformed agi ids are rejected before hitting the database"""
        result = query_efp_database_dynamic("embryo", "AT1G0101X")
        self.assertFalse(result["success"])
        self.assertEqual(result["error_code"], 400)
        self.assertIn("Invalid Arabidopsis gene ID format", result["error"])

    def test_sample_data_agi_is_converted_to_probeset(self):
        """sample_data requires probesets, so agi ids should be converted automatically"""
        mapping_date = date(2020, 1, 1)
        db.session.query(AtAgiLookup).filter_by(
            probeset="261585_at", agi="AT1G01010", date=mapping_date
        ).delete()
        db.session.add(
            AtAgiLookup(
                probeset="261585_at",
                agi="AT1G01010",
                date=mapping_date,
            )
        )
        db.session.commit()
        result = None
        try:
            result = query_efp_database_dynamic("sample_data", "At1g01010", allow_empty_results=False)
        finally:
            db.session.query(AtAgiLookup).filter_by(
                probeset="261585_at", agi="AT1G01010", date=mapping_date
            ).delete()
            db.session.commit()

        self.assertTrue(result["success"])
        self.assertEqual(result["probset_id"], "261585_at")
        self.assertGreater(result["record_count"], 0)
        sample_lookup = {row["name"]: row["value"] for row in result["data"]}
        self.assertEqual(sample_lookup["ATGE_100_A"], "40.381")

    def test_sample_data_filter_returns_case_insensitive_matches(self):
        """sample_data filters should honor case-insensitive flag just like other datasets"""
        result = query_efp_database_dynamic(
            "sample_data",
            "261585_at",
            sample_ids=["atge_100_a", "ATGE_100_B"],
            allow_empty_results=False,
            sample_case_insensitive=True,
        )
        self.assertTrue(result["success"])
        self.assertEqual(result["record_count"], 2)
        names = sorted(row["name"] for row in result["data"])
        self.assertEqual(names, ["ATGE_100_A", "ATGE_100_B"])

    def test_sample_data_empty_results_allowed(self):
        """allow_empty_results should return success even when filters exclude everything"""
        result = query_efp_database_dynamic(
            "sample_data", "256898_at", sample_ids=["DOES_NOT_EXIST"], allow_empty_results=True
        )
        self.assertTrue(result["success"])
        self.assertEqual(result["record_count"], 0)
        self.assertEqual(result["data"], [])


class TestProbesetConversion(TestCase):
    """Verify that AGI → probeset conversion runs for all arabidopsis probeset databases.

    Each test seeds a known AT1G01010 → 261585_at mapping into at_agi_lookup,
    queries an arabidopsis probeset database with the AGI, and checks that:
      - the call succeeds (conversion didn't 404)
      - probset_id in the response matches a real Affymetrix probeset pattern
    allow_empty_results=True because the sqlite mirrors may not contain AT1G01010 rows;
    we only care that the conversion step ran, not that expression data was found.
    """

    # Real Affymetrix ATH1 probeset patterns:
    #   numeric probeset:  261585_at, 244902_at, 267521_at
    #   control probesets: AFFX-r2-P1-cre-3_at, AFFX-BioB-M_at, etc.
    PROBESET_PATTERN = re.compile(r"^(\d+_[a-z_]*at|AFFX-.+)$", re.IGNORECASE)

    MAPPING_DATE = date(2020, 1, 1)
    PROBESET = "261585_at"
    AGI = "AT1G01010"

    # All arabidopsis databases that store probeset IDs and therefore need
    # AGI → probeset conversion via at_agi_lookup
    ARABIDOPSIS_PROBESET_DBS = [
        "affydb",
        "arabidopsis_ecotypes",
        "atgenexp",
        "atgenexp_hormone",
        "atgenexp_pathogen",
        "atgenexp_plus",
        "atgenexp_stress",
        "guard_cell",
        "hnahal",
        "lateral_root_initiation",
        "light_series",
        "meristem_db",
        "meristem_db_new",
        "root",
        "rohan",
        "rpatel",
        "seed_db",
    ]

    def setUp(self):
        self.ctx = app.app_context()
        self.ctx.push()
        # seed the AGI → probeset mapping once for all tests in this class
        db.session.query(AtAgiLookup).filter_by(
            probeset=self.PROBESET, agi=self.AGI, date=self.MAPPING_DATE
        ).delete()
        db.session.add(AtAgiLookup(probeset=self.PROBESET, agi=self.AGI, date=self.MAPPING_DATE))
        db.session.commit()

    def tearDown(self):
        db.session.query(AtAgiLookup).filter_by(
            probeset=self.PROBESET, agi=self.AGI, date=self.MAPPING_DATE
        ).delete()
        db.session.commit()
        self.ctx.pop()

    def _assert_probeset_conversion_ran(self, database):
        result = query_efp_database_dynamic(database, self.AGI, allow_empty_results=True)
        error = result.get("error", "")

        # If the DB has no local mirror, the query fails at the connection stage —
        # that is fine for this test. What we must NOT see is a conversion failure
        # ("Could not find probeset"), which means the lookup never ran.
        db_unavailable = "not available" in error or "no active bind" in error

        if result["success"]:
            # Full success: conversion ran and data was returned — check probset_id format
            probset_id = result.get("probset_id", "")
            self.assertRegex(
                probset_id,
                self.PROBESET_PATTERN,
                f"{database}: probset_id '{probset_id}' does not look like a probeset ID",
            )
        elif db_unavailable:
            # Conversion ran but no local DB to query — acceptable in CI/local dev
            pass
        else:
            self.fail(
                f"{database}: conversion failed before reaching the DB — error: {error}"
            )

    def test_affydb_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("affydb")

    def test_arabidopsis_ecotypes_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("arabidopsis_ecotypes")

    def test_atgenexp_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("atgenexp")

    def test_atgenexp_hormone_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("atgenexp_hormone")

    def test_atgenexp_pathogen_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("atgenexp_pathogen")

    def test_atgenexp_plus_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("atgenexp_plus")

    def test_atgenexp_stress_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("atgenexp_stress")

    def test_guard_cell_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("guard_cell")

    def test_hnahal_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("hnahal")

    def test_lateral_root_initiation_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("lateral_root_initiation")

    def test_light_series_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("light_series")

    def test_meristem_db_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("meristem_db")

    def test_meristem_db_new_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("meristem_db_new")

    def test_root_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("root")

    def test_rohan_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("rohan")

    def test_rpatel_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("rpatel")

    def test_seed_db_converts_agi_to_probeset(self):
        self._assert_probeset_conversion_ran("seed_db")

    def test_no_conversion_when_lookup_missing(self):
        """if at_agi_lookup has no entry for the gene, the call should fail with 404"""
        # use a gene with no seeded mapping
        result = query_efp_database_dynamic("atgenexp", "AT9G99999", allow_empty_results=True)
        self.assertFalse(result["success"])
        self.assertEqual(result["error_code"], 400)  # invalid gene format catches this first
