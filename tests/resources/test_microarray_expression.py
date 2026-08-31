from api import app
from api.utils.bar_utils import load_combined_master
from unittest import TestCase
from json import load


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_world_eFP_expression(self):
        """This tests the data returned by the world efp end point
        :return:
        """
        # Valid data
        response = self.app_client.get("/microarray_gene_expression/world_efp/arabidopsis/At1g01010")
        with open("tests/data/get_microarray_expression.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

        # Invalid gene
        response = self.app_client.get("/microarray_gene_expression/world_efp/arabidopsis/At1g0101x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Invalid species
        response = self.app_client.get("/microarray_gene_expression/world_efp/abc/At1g01010")
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(response.json, expected)

        # No data for a valid gene
        response = self.app_client.get("/microarray_gene_expression/world_efp/arabidopsis/At1g01011")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)


class TestGetDatabases(TestCase):
    """/microarray_gene_expression/<species>/databases -- sourced from combined_master.json."""

    def setUp(self):
        self.app_client = app.test_client()
        self.master = load_combined_master()

    def test_valid_species_matches_master_json(self):
        response = self.app_client.get("/microarray_gene_expression/arabidopsis/databases")
        self.assertTrue(response.json["wasSuccessful"])
        data = response.json["data"]

        expected_dbs = {
            db_name for db_name, info in self.master["databases"].items()
            if info["species"] == "arabidopsis"
        }
        self.assertEqual(data["num_databases"], len(expected_dbs))
        # Only databases with at least one live frontend view (used_by) can
        # appear in a view-name -> database mapping; legacy/hidden databases
        # (e.g. affydb, rohan) are counted in num_databases but have no view.
        expected_dbs_with_views = {
            db_name for db_name in expected_dbs
            if self.master["databases"][db_name]["used_by"]
        }
        self.assertEqual(set(data["databases"].values()), expected_dbs_with_views)

    def test_species_case_insensitive(self):
        response = self.app_client.get("/microarray_gene_expression/Arabidopsis/databases")
        self.assertTrue(response.json["wasSuccessful"])

    def test_species_previously_split_across_fake_subspecies_is_unified(self):
        """cacao_ccn/cacao_sca/cacao_tc databases used to be modelled as three
        fake pseudo-species ("cacao ccn", "cacao sca", "cacao tc"); the
        master-JSON-backed endpoint reports them under the one real species."""
        response = self.app_client.get("/microarray_gene_expression/cacao/databases")
        self.assertTrue(response.json["wasSuccessful"])
        data = response.json["data"]
        self.assertGreaterEqual(data["num_databases"], 6)

    def test_invalid_species_rejected(self):
        response = self.app_client.get("/microarray_gene_expression/not_a_real_species/databases")
        self.assertEqual(response.json, {"wasSuccessful": False, "error": "Invalid species"})


class TestGetSamples(TestCase):
    """/microarray_gene_expression/<species>/<view>/samples -- sourced from combined_master.json."""

    def setUp(self):
        self.app_client = app.test_client()

    def test_single_view_returns_groups(self):
        response = self.app_client.get("/microarray_gene_expression/arabidopsis/Abiotic_Stress/samples")
        self.assertTrue(response.json["wasSuccessful"])
        data = response.json["data"]
        self.assertEqual(data["database"], "atgenexp_stress")
        self.assertIn("groups", data)
        self.assertTrue(len(data["groups"]) > 0)

    def test_all_views_returns_every_view_for_species(self):
        response = self.app_client.get("/microarray_gene_expression/arabidopsis/all/samples")
        self.assertTrue(response.json["wasSuccessful"])
        self.assertIn("Abiotic_Stress", response.json["data"]["views"])

    def test_invalid_view_rejected(self):
        response = self.app_client.get("/microarray_gene_expression/arabidopsis/NotARealView/samples")
        self.assertEqual(
            response.json, {"wasSuccessful": False, "error": "Invalid view for this species"}
        )

    def test_invalid_species_rejected(self):
        response = self.app_client.get("/microarray_gene_expression/not_a_real_species/Abiotic_Stress/samples")
        self.assertEqual(response.json, {"wasSuccessful": False, "error": "Invalid species"})
