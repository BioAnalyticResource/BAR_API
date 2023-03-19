from api import app
from unittest import TestCase
import json


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_loc(self):
        """
        This function test retrieving subcellular localizations for various species' genes via GET.
        """

        # Valid request rice
        response = self.app_client.get("/loc/rice/LOC_Os01g52560.1")
        expected = {
            "wasSuccessful": True,
            "data": {
                "gene": "LOC_Os01g52560.1",
                "predicted_location": "Cellmembrane,Chloroplast",
            },
        }
        self.assertEqual(response.json, expected)

        # Invalid species
        response = self.app_client.get("/loc/poplar/LOC_Os01g52560.1")
        expected = {"wasSuccessful": False, "error": "Invalid species or gene ID"}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/loc/rice/abc")
        expected = {"wasSuccessful": False, "error": "Invalid species or gene ID"}
        self.assertEqual(response.json, expected)

        # Gene does not exist
        response = self.app_client.get("/loc/rice/LOC_Os01g52561.1")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

    def test_post_loc(self):
        """
        This function test retrieving subcellular localizations for various species' genes via POST.
        """

        # Valid request
        response = self.app_client.post(
            "/loc/",
            json={"species": "rice", "genes": ["LOC_Os01g01080.1", "LOC_Os01g52560.1"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": True,
            "data": {
                "LOC_Os01g01080.1": ["Endoplasmic reticulum"],
                "LOC_Os01g52560.1": ["Cellmembrane,Chloroplast"],
            },
        }
        self.assertEqual(data, expected)

        # Invalid species
        response = self.app_client.post(
            "/loc/",
            json={
                "species": "poplar",
                "genes": ["LOC_Os01g01080.1", "LOC_Os01g52560.1"],
            },
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(data, expected)

        # Invalid gene ID
        response = self.app_client.post("/loc/", json={"species": "rice", "genes": ["abc", "xyz"]})
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(data, expected)

        # No data for valid gene IDs
        response = self.app_client.post(
            "/loc/",
            json={"species": "rice", "genes": ["LOC_Os01g01085.1", "LOC_Os01g52565.1"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(data, expected)
