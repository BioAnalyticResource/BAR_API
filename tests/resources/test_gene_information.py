from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_gene_alias_list(self):
        """This function tests the gene alias list get function
        :return:
        """
        response = self.app_client.get('/gene_information/gene_alias')
        expected = {
            "wasSuccessful": True,
            "data": [
                "arabidopsis"
            ]
        }
        self.assertEqual(response.json, expected)

    def test_get_arabidopsis_gene_alias(self):
        """This tests checks GET request for gene alias Arabidopsis
        :return:
        """
        # Valid data
        response = self.app_client.get('/gene_information/gene_alias/arabidopsis/At3g24650')
        expected = {
            "wasSuccessful": True,
            "data": [
                "ABI3",
                "AtABI3",
                "SIS10"
            ]
        }
        self.assertEqual(response.json, expected)

        # Data not found, but gene is valid
        response = self.app_client.get('/gene_information/gene_alias/arabidopsis/At3g24651')
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene"
        }
        self.assertEqual(response.json, expected)

        # Invalid Gene
        response = self.app_client.get('/gene_information/gene_alias/arabidopsis/At3g2465x')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid gene id"
        }
        self.assertEqual(response.json, expected)

        # Invalid Species
        response = self.app_client.get('/gene_information/gene_alias/x/At3g24650')
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species"
        }
        self.assertEqual(response.json, expected)
