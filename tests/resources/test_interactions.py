from api import app
from unittest import TestCase
import json
from json import load


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

    def test_single_itrn(self):
        """
        This function tests retrieving a single interaction by ID.
        """

        # Valid request
        response = self.app_client.get("/interactions/single_interaction/80")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "interaction_id": 80,
                    "pearson_correlation_coeff": None,
                    "entity_1": "AT4G25470",
                    "entity_2": "AT5G50720",
                    "interaction_type_id": 1
                }
            ]
        }
        self.assertEqual(response.json, expected)

        # Input not a number
        response = self.app_client.get("/interactions/single_interaction/g")
        expected = {
            "wasSuccessful": False,
            "error": "ID given was not a number!"
        }
        self.assertEqual(response.json, expected)

        # Not a valid interaction ID
        response = self.app_client.get("/interactions/single_interaction/3")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid interaction ID"
        }
        self.assertEqual(response.json, expected)

    def test_itrn_by_ref(self):
        """
        This function tests retrieving interactions linked to a specific paper ID
        """

        # Valid request
        response = self.app_client.get("/interactions/interactions_by_ref/20")
        with open("tests/data/interactions_by_ref.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

        # Input not a number
        response = self.app_client.get("/interactions/interactions_by_ref/k")
        expected = {
            "wasSuccessful": False,
            "error": "ID given was not a number!"
        }
        self.assertEqual(response.json, expected)

        # Not a valid paper ID
        response = self.app_client.get("/interactions/interactions_by_ref/1")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid paper ID"
        }
        self.assertEqual(response.json, expected)

    def test_all_tags(self):
        """
        This function tests retrieval of all available tag names and their groups.
        """

        # Valid request
        response = self.app_client.get("/interactions/all_tags")
        with open("tests/data/all_tags.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

    def test_search_by_tag(self):
        """
        This function tests searching for sources associated with a given tag.
        """

        # Valid request
        response = self.app_client.get("/interactions/search_by_tag/CZF1")
        with open("tests/data/search_by_tag.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

        # Invalid tag name
        response = self.app_client.get("/interactions/search_by_tag/p")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid tag name"
        }
        self.assertEqual(response.json, expected)

    def test_get_all_papers(self):
        """
        This function tests retrieval of all papers with their metadata.
        """

        # Valid request
        response = self.app_client.get("/interactions/get_all_papers")
        with open("tests/data/get_all_papers.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

    def test_get_paper(self):
        """
        This function tests retrieving a single paper by its ID.
        """

        # Valid request
        response = self.app_client.get("/interactions/get_paper/16")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "source_id": 16,
                    "source_name": "25736223#2",
                    "comments": "Topic:Investigating cold regulation of the CBF regulon. Methods include transgenic lines that constitutively overexpressed a truncated version of CBF2, quantitative real time PCR analysis, affymetrix GeneChip hybridization. Data From: Table S6. This GRN is specifically for HSFC1 regulon genes up-regulated by first wave transcription factors.",
                    "date_uploaded": "2019/11/12",
                    "url": "www.ncbi.nlm.nih.gov/pubmed/25736223",
                    "image_url": "https://bar.utoronto.ca/GRN_Images/25736223%232.jpg",
                    "grn_title": "Park et al.(The Plant Journal, 2015) CBF Regulon Low Temperature Network",
                    "cyjs_layout": "{\"name\": \"breadthfirst\", \"animate\" : \"true\"}"
                }
            ]
        }
        self.assertEqual(response.json, expected)

        # Input not an integer, a string
        response = self.app_client.get("/interactions/get_paper/p")
        expected = {
            "wasSuccessful": False,
            "error": "Input number is not an integer!"
        }
        self.assertEqual(response.json, expected)

        # Input not an integer, a float
        response = self.app_client.get("/interactions/get_paper/2.2")
        expected = {
            "wasSuccessful": False,
            "error": "Input number is not an integer!"
        }
        self.assertEqual(response.json, expected)

        # Invalid source ID
        response = self.app_client.get("/interactions/get_paper/3")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid source ID"
        }
        self.assertEqual(response.json, expected)

    def test_get_paper_by_agi(self):
        """
        This function tests retrieving papers that contain a specific AGI in interaction data.
        """

        # Valid request
        response = self.app_client.get("/interactions/get_paper_by_agi/AT1G22770")
        with open("tests/data/get_paper_by_agi.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

        # Invalid AGI
        response = self.app_client.get("/interactions/get_paper_by_agi/AT1G00000")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid AGI"
        }
        self.assertEqual(response.json, expected)

    def test_get_paper_by_agi_pair(self):
        """
        This function tests retrieving papers where either AGIs appear in interaction data.
        """

        # Valid request
        response = self.app_client.get("/interactions/get_paper_by_agi_pair/AT5G50000/AT1G77120")
        with open("tests/data/get_paper_by_agi_pair.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

        # Both AGI invalid
        response = self.app_client.get("/interactions/get_paper_by_agi_pair/AT1G00000/AT2G00000")
        expected = {
            "wasSuccessful": False,
            "error": "Both AGI invalid"
        }
        self.assertEqual(response.json, expected)

    def test_get_all_grns(self):
        """
        This function tests retrieval of all GRNs with their associated tags.
        """

        # Valid request
        response = self.app_client.get("/interactions/get_all_grns")
        with open("tests/data/get_all_grns.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)
