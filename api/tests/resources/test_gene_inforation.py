from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app = app.test_client()

    def test_arabidopsis_gene_alias(self):
        """
        This tests check for a gene alias for the Arabidopsis gene ABI3
        :return:
        """
        response = self.app.get('/gene_information/gene_alias/arabidopsis/At3g24650')
        expected = {
            "success": True,
            "data": [
                "ABI3",
                "AtABI3",
                "SIS10"
            ]
        }
        self.assertEqual(response.json, expected)

    def test_arabidopsis_gene_not_found(self):
        """
        This function tests for genes that do not exists
        :return:
        """
        response = self.app.get('/gene_information/gene_alias/arabidopsis/At3g24651')
        expected = {
            "success": False,
            "error": "There is no data found for the given gene"
        }
        self.assertEqual(response.json, expected)

    def test_arabidopsis_gene_not_valid(self):
        """
        This function tests for genes that are not valid
        :return:
        """
        response = self.app.get('/gene_information/gene_alias/arabidopsis/At3g2465x')
        expected = {
            "success": False,
            "error": "Invalid gene id"
        }
        self.assertEqual(response.json, expected)

    def test_species_not_found(self):
        """
        This function tests if species is available
        :return:
        """
        response = self.app.get('/gene_information/gene_alias/x/At3g24650')
        expected = {
            "success": False,
            "error": "No data for the given species"
        }
        self.assertEqual(response.json, expected)
