from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_keyword_search(self):
        # A working version
        test_query = "alpha-1 protein"
        response = self.app_client.get(f"/gene_annotation/{test_query}")
        expected = {
            "status": "success",
            "query": "alpha-1 protein",
            "result": [
                {
                    "gene": "Potri.001G000700.1",
                    "species": "poplar",
                    "gene_annotation": "similar to PUR alpha-1 protein; similar to PUR alpha-1 GI:5081612 from (Arabidopsis thaliana); similar to PUR alpha-1 protein; similar to PUR alpha-1 GI:5081612 from (Arabidopsis thaliana); [ co-ortholog (1of2) of At2g32080, ]",
                },
                {
                    "gene": "Potri.001G000700.2",
                    "species": "poplar",
                    "gene_annotation": "similar to PUR alpha-1 protein; similar to PUR alpha-1 GI:5081612 from (Arabidopsis thaliana); similar to PUR alpha-1 protein; similar to PUR alpha-1 GI:5081612 from (Arabidopsis thaliana); [ co-ortholog (1of2) of At2g32080, ]",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        # Not working version
        test_query = "alpha-1 protein"
        response = self.app_client.get("/gene_annotation/abc")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given query",
        }
        self.assertEqual(response.json, expected)
