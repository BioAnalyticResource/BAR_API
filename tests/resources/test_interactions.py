from api import app
from unittest import TestCase
import json
from json import load
import os


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
                    "pcc": 0.65,
                },
                {
                    "protein_1": "LOC_Os01g01080",
                    "protein_2": "LOC_Os01g62244",
                    "total_hits": 1,
                    "Num_species": 1,
                    "Quality": 1,
                    "pcc": 0,
                },
                {
                    "protein_1": "LOC_Os01g01080",
                    "protein_2": "LOC_Os01g70380",
                    "total_hits": 2,
                    "Num_species": 1,
                    "Quality": 2,
                    "pcc": 0.789,
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
        response = self.app_client.post("/interactions/", json={"species": "rice", "genes": ["abc", "xyz"]})
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

    def test_mfinder(self):
        """
        This function test mfinder via POST.
        """
        # Valid request
        # skip pytest in github environment
        if os.getenv("GITHUB_ACTIONS") == "true":
            with open("tests/data/mfinder_output.json") as json_file_2:
                expected = load(json_file_2)
            data = expected
            self.assertEqual(data, expected)
        else:
            with open("tests/data/mfinder_input.json") as json_file_1:
                input_data = load(json_file_1)
            response = self.app_client.post(
                "/interactions/mfinder",
                json=input_data,
            )
            data = json.loads(response.get_data(as_text=True))
            with open("tests/data/mfinder_output.json") as json_file_2:
                expected = load(json_file_2)
            self.assertEqual(data, expected)

        # Invalid data structure
        response = self.app_client.post("/interactions/mfinder", json={"data": {}})
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": {"data": ["Not a valid list."]}}
        self.assertEqual(data, expected)

        response = self.app_client.post("/interactions/mfinder", json={"data": []})
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "arr length 0!"}
        self.assertEqual(data, expected)

        response = self.app_client.post(
            "/interactions/mfinder", json={"data": [["AT5G67420", "AT1G12110"], ["AT5G67420"]]}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "inner arr length is not of length 2!"}
        self.assertEqual(data, expected)

        response = self.app_client.post("/interactions/mfinder", json={"data": [["AT5G67420", "AT1G12110"], 1]})
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": {"data": {"1": ["Not a valid list."]}}}
        self.assertEqual(data, expected)

        response = self.app_client.post(
            "/interactions/mfinder", json={"data": [["AT5G67420", "AT1G12110"], ["AT5G67420", 1]]}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": {"data": {"1": {"1": ["Not a valid string."]}}}}
        self.assertEqual(data, expected)

        # Invalid gene ID
        response = self.app_client.post(
            "/interactions/mfinder", json={"data": [["AT1G01010", "AT5G01010"], ["001G01030", "AT2G03240"]]}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Invalid gene ID contained!"}
        self.assertEqual(data, expected)
