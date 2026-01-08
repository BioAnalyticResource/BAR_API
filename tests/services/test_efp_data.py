import os
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
