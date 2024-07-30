from api import app
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
