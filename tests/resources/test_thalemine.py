from api import app
from json import load
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_thalemine_gene_rifs(self):
        """This tests the data returned by the ThaleMine Gene RIFs
        :return:
        """
        # Valid data
        response = self.app_client.get("/thalemine/gene_rifs/At1g01020")

        # Delete query time data. It will always be different
        response = response.json
        response.pop("executionTime")

        # Note: pytest is running from project root. So path is relative to project root
        # Also, delete execution time from output before saving.
        with open("tests/data/get_thalemine_gene_rifs_1.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response, expected)

        # Anther valid gene
        response = self.app_client.get("/thalemine/gene_rifs/At1g01050")

        # Delete query time data. It will always be different
        response = response.json
        response.pop("executionTime")

        # Note: pytest is running from project root. So path is relative to project root
        # Also, delete execution time from output before saving.
        with open("tests/data/get_thalemine_gene_rifs_3.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response, expected)

        # Valid but does not exists
        response = self.app_client.get("/thalemine/gene_rifs/At1g01010")

        # Again, delete time data.
        response = response.json
        response.pop("executionTime")

        with open("tests/data/get_thalemine_gene_rifs_2.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response, expected)

        # Invalid gene id
        response = self.app_client.get("/thalemine/gene_rifs/At1g0101x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

    def test_get_thalemine_publications(self):
        """This tests the data returned by the ThaleMine publications endpoint
        :return:
        """
        # Valid data
        response = self.app_client.get("/thalemine/publications/At1g01020")

        # Delete query time data. It will always be different
        response = response.json
        response.pop("executionTime")

        # Note: pytest is running from project root. So path is relative to project root
        # Also, delete execution time from output before saving.
        with open("tests/data/get_thalemine_publications_1.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response, expected)

        # Valid but does not exists
        response = self.app_client.get("/thalemine/publications/At1g01011")

        # Again, delete time data.
        response = response.json
        response.pop("executionTime")

        with open("tests/data/get_thalemine_publications_2.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response, expected)

        # Invalid gene id
        response = self.app_client.get("/thalemine/publications/At1g0101x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)
