from api import app
from unittest import TestCase
import json


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

    def test_post_gene_annotation(self):
        """
        This function test retrieving gene annotations for various species' genes via POST.
        """

        # Valid request
        response = self.app_client.post(
            "/gene_annotation/",
            json={"species": "rice", "genes": ["LOC_Os01g01010", "LOC_Os01g01050"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "gene": "LOC_Os01g01010",
                    "annotation": "protein TBC domain containing protein, expressed",
                },
                {
                    "gene": "LOC_Os01g01050",
                    "annotation": "protein R3H domain containing protein, expressed",
                },
            ],
        }
        self.assertEqual(data, expected)

        # Invalid species
        response = self.app_client.post(
            "/gene_annotation/",
            json={"species": "poplar", "genes": ["LOC_Os01g01080", "LOC_Os01g73310"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(data, expected)

        # Invalid gene ID
        response = self.app_client.post("/interactions/", json={"species": "rice", "genes": ["abc", "xyz"]})
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(data, expected)

        # No data for valid gene IDs
        response = self.app_client.post(
            "/gene_annotation/",
            json={"species": "rice", "genes": ["LOC_Os01g01085", "LOC_Os01g52565"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(data, expected)
