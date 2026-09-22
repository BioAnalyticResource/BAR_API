"""
Tests for the /gene_expression/expression/<database>/<gene_id> endpoint.
"""
from datetime import date
from unittest import TestCase

from api import app, db
from api.models.annotations_lookup import AtAgiLookup
from api.models.efp_dynamic import SAMPLE_DATA_MODELS


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


class TestSignalStdColumn(TestCase):
    """data_signal_std is exposed only for databases whose schema_variant declares it."""

    def setUp(self):
        self.client = app.test_client()

    def test_only_the_pseudobulk_model_maps_data_signal_std(self):
        """The variant-aware model generator has to stay a no-op for every other database."""
        with_std = {name for name, model in SAMPLE_DATA_MODELS.items() if hasattr(model, "data_signal_std")}
        self.assertEqual(
            with_std,
            {
                "arabidopsis_NIE_pseudobulk",
                "arabidopsis_flower_lee_pseudobulk",
                "arabidopsis_root_shahan_pseudobulk",
                "arabidopsis_rosette_21d_lee_pseudobulk",
                "arabidopsis_rosette_30d_lee_pseudobulk",
                "arabidopsis_seed_0d_lee_pseudobulk",
                "arabidopsis_seed_martin_pseudobulk",
                "arabidopsis_seedling_12d_lee_pseudobulk",
                "arabidopsis_seedling_3d_lee_pseudobulk",
                "arabidopsis_seedling_6d_lee_pseudobulk",
                "arabidopsis_shoot_zhang_pseudobulk",
                "arabidopsis_silique_lee_pseudobulk",
                "arabidopsis_stem_lee_pseudobulk",
                "rice_OW_pseudobulk",
            },
        )

    def test_pseudobulk_rows_carry_value_std(self):
        response = self.client.get("/gene_expression/expression/arabidopsis_NIE_pseudobulk/AT1G01010")
        self.assertEqual(response.status_code, 200)
        rows = response.json["data"]["data"]
        self.assertTrue(rows)
        for row in rows:
            self.assertEqual(set(row), {"name", "value", "value_std"})

    def test_pseudobulk_value_std_is_the_stored_column(self):
        """value_std must be data_signal_std, not a second copy of data_signal."""
        response = self.client.get("/gene_expression/expression/arabidopsis_NIE_pseudobulk/AT1G01010")
        self.assertEqual(response.status_code, 200)
        rows = {row["name"]: row for row in response.json["data"]["data"]}
        self.assertIn("D0_Mesophyll", rows)
        self.assertAlmostEqual(float(rows["D0_Mesophyll"]["value"]), 0.0346533, places=5)
        self.assertAlmostEqual(float(rows["D0_Mesophyll"]["value_std"]), 0.224356, places=5)

    def test_mean_ctrl_is_returned_inline_as_an_ordinary_row(self):
        """Mean_CTRL is the eFP view XML's <control> denominator, but it is stored like any
        other data_bot_id. Rendering that distinction belongs to the view layer, so the
        endpoint must not partition it out into a separate response key."""
        response = self.client.get("/gene_expression/expression/arabidopsis_NIE_pseudobulk/AT1G01010")
        self.assertEqual(response.status_code, 200)
        payload = response.json["data"]
        self.assertEqual(set(payload), {"gene_id", "probset_id", "database", "record_count", "data"})

        names = [row["name"] for row in payload["data"]]
        self.assertIn("Mean_CTRL", names)
        self.assertEqual(names.count("Mean_CTRL"), 1)
        self.assertEqual(payload["record_count"], len(payload["data"]))

        mean_row = next(row for row in payload["data"] if row["name"] == "Mean_CTRL")
        self.assertEqual(set(mean_row), {"name", "value", "value_std"})

    def test_other_databases_keep_the_two_key_row_shape(self):
        """Guards the additive-only promise: no new key may appear for the other databases."""
        response = self.client.get("/gene_expression/expression/klepikova/AT1G01010")
        self.assertEqual(response.status_code, 200)
        payload = response.json["data"]
        self.assertEqual(set(payload), {"gene_id", "probset_id", "database", "record_count", "data"})
        self.assertTrue(payload["data"])
        for row in payload["data"]:
            self.assertEqual(set(row), {"name", "value"})


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
