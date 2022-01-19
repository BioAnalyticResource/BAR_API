from api import app
from unittest import TestCase
import json


class TestIntegrations(TestCase):

    def setUp(self):
        self.app_client = app.test_client()

    def test_get_itrns(self):
        """
        This function test retrieving protein interactions for various species' genes.
        """

        # Valid request rice
        response = self.app_client.get("/interactions/rice/LOC_Os01g52560")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "protein_1": "LOC_Os01g01080",
                    "protein_2": "LOC_Os01g52560",
                    "total_hits": 1,
                    "Num_species": 1,
                    "Quality": 1,
                    "pcc": 0.65,
                },
                {
                    "protein_1": "LOC_Os01g52560",
                    "protein_2": "LOC_Os01g73310",
                    "total_hits": 1,
                    "Num_species": 1,
                    "Quality": 1,
                    "pcc": -0.116,
                },
            ],
        }
        self.assertEqual(response.json, expected)

        # Invalid species
        response = self.app_client.get("/interactions/poplar/abc")
        expected = {"wasSuccessful": False, "error": "Invalid species or gene ID"}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/interactions/rice/abc")
        expected = {"wasSuccessful": False, "error": "Invalid species or gene ID"}
        self.assertEqual(response.json, expected)

        # Gene does not exist
        response = self.app_client.get("/interactions/rice/LOC_Os01g52565")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

    def test_post_itrns(self):
        """
        This function test retrieving protein interactions for various species' genes via POST.
        """

        # Valid request
        response = self.app_client.post(
            "/interactions/",
            json={"species": "rice", "genes": ["LOC_Os01g01080", "LOC_Os01g73310"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "protein_1": "LOC_Os01g01080",
                    "protein_2": "LOC_Os01g52560",
                    "total_hits": 1,
                    "Num_species": 1,
                    "Quality": 1,
                    "pcc": 0.65
                },
                {
                    "protein_1": "LOC_Os01g01080",
                    "protein_2": "LOC_Os01g62244",
                    "total_hits": 1,
                    "Num_species": 1,
                    "Quality": 1,
                    "pcc": 0
                },
                {
                    "protein_1": "LOC_Os01g01080",
                    "protein_2": "LOC_Os01g70380",
                    "total_hits": 2,
                    "Num_species": 1,
                    "Quality": 2,
                    "pcc": 0.789
                },
                {
                    "protein_1": "LOC_Os01g52560",
                    "protein_2": "LOC_Os01g73310",
                    "total_hits": 1,
                    "Num_species": 1,
                    "Quality": 1,
                    "pcc": -0.116
                }
            ]
        }
        self.assertEqual(data, expected)

        # Invalid species
        response = self.app_client.post(
            "/interactions/",
            json={"species": "poplar", "genes": ["LOC_Os01g01080", "LOC_Os01g73310"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(data, expected)

        # Invalid gene ID
        response = self.app_client.post(
            "/interactions/", json={"species": "rice", "genes": ["abc", "xyz"]}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(data, expected)

        # No data for valid gene IDs
        response = self.app_client.post(
            "/interactions/",
            json={"species": "rice", "genes": ["LOC_Os01g01085", "LOC_Os01g52565"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(data, expected)
