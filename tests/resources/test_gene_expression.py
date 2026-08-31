"""
Tests for the /gene_expression/expression/<database>/<gene_id> endpoint.
"""
from datetime import date
from unittest import TestCase

from api import app, db
from api.models.annotations_lookup import AtAgiLookup


class TestGeneExpression(TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_unknown_database_rejected(self):
        response = self.client.get("/gene_expression/expression/not_a_real_db/AT1G01010")
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json["error"], "Invalid species or gene ID")

    def test_invalid_gene_id_rejected(self):
        response = self.client.get("/gene_expression/expression/klepikova/NOTAGENEID")
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json["error"], "Invalid species or gene ID")

    def test_sql_injection_rejected(self):
        response = self.client.get("/gene_expression/expression/klepikova/AT1G01010'%20OR%20'1'='1")
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json["error"], "Invalid species or gene ID")

    def test_gene_model_database_returns_data(self):
        """klepikova stores rows by gene ID directly -- no probeset lookup needed."""
        response = self.client.get("/gene_expression/expression/klepikova/AT1G01010")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json["wasSuccessful"])
        self.assertEqual(response.json["data"]["probset_id"], "AT1G01010")

    def test_gene_id_case_insensitive(self):
        response = self.client.get("/gene_expression/expression/klepikova/at1g01010")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json["data"]["gene_id"], "at1g01010")

    def test_no_data_found_returns_distinct_message(self):
        """A well-formed but unmapped gene ID is a different failure than a malformed one."""
        response = self.client.get("/gene_expression/expression/klepikova/AT5G99999")
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json["error"], "There are no data found for the given gene")

    def test_probeset_database_accepts_probeset_directly(self):
        """arabidopsis_ecotypes stores rows by probeset -- a probeset-shaped ID skips the AGI lookup."""
        response = self.client.get("/gene_expression/expression/arabidopsis_ecotypes/261585_at")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json["data"]["probset_id"], "261585_AT")


class TestAgiToProbesetConversion(TestCase):
    """Covers the AGI -> probeset lookup path for probeset-keyed databases."""

    PROBESET = "261585_at"
    AGI = "AT1G01010"
    # a date far from any real seed row, so setUp/tearDown only ever touch this one row
    MAPPING_DATE = date(2020, 1, 1)

    def setUp(self):
        self.client = app.test_client()
        with app.app_context():
            db.session.query(AtAgiLookup).filter_by(agi=self.AGI, probeset=self.PROBESET, date=self.MAPPING_DATE).delete()
            db.session.add(AtAgiLookup(agi=self.AGI, probeset=self.PROBESET, date=self.MAPPING_DATE))
            db.session.commit()

    def tearDown(self):
        with app.app_context():
            db.session.query(AtAgiLookup).filter_by(agi=self.AGI, probeset=self.PROBESET, date=self.MAPPING_DATE).delete()
            db.session.commit()

    def test_agi_converts_to_probeset_before_query(self):
        response = self.client.get("/gene_expression/expression/arabidopsis_ecotypes/{}".format(self.AGI))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json["data"]["probset_id"], self.PROBESET)

    def test_unmapped_agi_rejected(self):
        response = self.client.get("/gene_expression/expression/arabidopsis_ecotypes/AT5G99998")
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json["error"], "Invalid species or gene ID")
