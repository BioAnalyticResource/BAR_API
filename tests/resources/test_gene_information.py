from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_arabidopsis_gene_alias(self):
        """This tests checks GET request for gene alias Arabidopsis
        :return:
        """
        # Valid data
        response = self.app_client.get("/gene_information/gene_alias/arabidopsis/At3g24650")
        expected = {"wasSuccessful": True, "data": ["ABI3", "AtABI3", "SIS10"]}
        self.assertEqual(response.json, expected)

        # Data not found, but gene is valid
        response = self.app_client.get("/gene_information/gene_alias/arabidopsis/At3g24651")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        # Invalid Gene
        response = self.app_client.get("/gene_information/gene_alias/arabidopsis/At3g2465x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Invalid Species
        response = self.app_client.get("/gene_information/gene_alias/x/At3g24650")
        expected = {"wasSuccessful": False, "error": "No data for the given species"}
        self.assertEqual(response.json, expected)

    def test_post_gene_alias_list(self):
        """This function tests the gene alias list get function
        :return:
        """
        pass

    def test_get_arabidopsis_gene_isoform(self):
        """This tests checks GET request for gene isoforms Arabidopsis
        :return:
        """
        # Valid data
        response = self.app_client.get("/gene_information/gene_isoforms/arabidopsis/AT1G01020")
        expected = {"wasSuccessful": True, "data": ["AT1G01020.1", "AT1G01020.2"]}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/poplar/Potri.001G000300")
        expected = {"wasSuccessful": True, "data": ["Potri.001G000300.1"]}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/tomato/Solyc00g005000")
        expected = {"wasSuccessful": True, "data": ["Solyc00g005000.3.1"]}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/soybean/Glyma.01G000100")
        expected = {"wasSuccessful": True, "data": ["Glyma.01G000100"]}
        self.assertEqual(response.json, expected)

        # Data not found, but gene is valid
        response = self.app_client.get("/gene_information/gene_isoforms/arabidopsis/At3g24651")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        # Data not found, but gene is valid
        response = self.app_client.get("/gene_information/gene_isoforms/poplar/Potri.001G000201")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/tomato/Solyc00g005001")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/soybean/Glyma.01G000102")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        # Invalid Gene
        response = self.app_client.get("/gene_information/gene_isoforms/arabidopsis/At3g2465x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/poplar/Potri.001G00020x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/tomato/Solyc00g00500x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/soybean/Glyma.01G00010x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Invalid Species
        response = self.app_client.get("/gene_information/gene_isoforms/x/At3g24650")
        expected = {"wasSuccessful": False, "error": "No data for the given species"}
        self.assertEqual(response.json, expected)

    def test_post_arabidopsis_gene_isoform(self):
        """This tests the data returned for Arabidopsis gene isoforms.
        :return:
        """
        # Valid example
        data = {"species": "arabidopsis", "genes": ["AT1G01010", "AT1G01020"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01010": ["AT1G01010.1"],
                "AT1G01020": ["AT1G01020.1", "AT1G01020.2"],
            },
        }
        self.assertEqual(response.json, expected)

        data = {"species": "poplar", "genes": ["Potri.001G000300", "Potri.001G000400"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "Potri.001G000300": ["Potri.001G000300.1"],
                "Potri.001G000400": [
                    "Potri.001G000400.1",
                    "Potri.001G000400.2",
                    "Potri.001G000400.3",
                    "Potri.001G000400.4",
                ],
            },
        }
        self.assertEqual(response.json, expected)

        data = {"species": "soybean", "genes": ["Glyma.01G000100", "Glyma.01G000200"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "Glyma.01G000100": ["Glyma.01G000100"],
                "Glyma.01G000200": ["Glyma.01G000200"],
            },
        }
        self.assertEqual(response.json, expected)

        data = {"species": "tomato", "genes": ["Solyc00g005000"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"Solyc00g005000": ["Solyc00g005000.3.1"]},
        }
        self.assertEqual(response.json, expected)

        # Invalid data in JSON
        data = {
            "species": "arabidopsis",
            "genes": ["AT1G01010", "AT1G01020"],
            "abc": "xyz",
        }
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": {"abc": ["Unknown field."]}}
        self.assertEqual(response.json, expected)

        data = {
            "species": "poplar",
            "genes": ["Potri.001G000200", "Potri.001G000300"],
            "abc": "xyz",
        }
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": {"abc": ["Unknown field."]}}
        self.assertEqual(response.json, expected)

        data = {
            "species": "soybean",
            "genes": ["Glyma.01G000100", "Glyma.01G000200"],
            "abc": "xyz",
        }
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": {"abc": ["Unknown field."]}}
        self.assertEqual(response.json, expected)

        # Data not found for a valid gene
        data = {"species": "arabidopsis", "genes": ["AT1G01011", "AT1G01020"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"AT1G01020": ["AT1G01020.1", "AT1G01020.2"]},
        }
        self.assertEqual(response.json, expected)

        data = {"species": "poplar", "genes": ["Potri.001G000201", "Potri.001G000300"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"Potri.001G000300": ["Potri.001G000300.1"]},
        }
        self.assertEqual(response.json, expected)

        data = {"species": "soybean", "genes": ["Glyma.01G000100", "Glyma.01G000101"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"Glyma.01G000100": ["Glyma.01G000100"]},
        }
        self.assertEqual(response.json, expected)

        # Check if arabidopsis gene is valid
        data = {"species": "arabidopsis", "genes": ["AT1G01011", "AT1G01020"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"AT1G01020": ["AT1G01020.1", "AT1G01020.2"]},
        }
        self.assertEqual(response.json, expected)

        # Check if gene is valid
        data = {"species": "arabidopsis", "genes": ["abc"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        data = {"species": "poplar", "genes": ["abc"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        data = {"species": "tomato", "genes": ["abc"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        data = {"species": "soybean", "genes": ["abc"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Check if there is data for the given gene
        data = {"species": "arabidopsis", "genes": ["AT1G01011"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)

        # Check if species is valid
        data = {"species": "abc", "genes": ["AT1G01010", "AT1G01020"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(response.json, expected)

        # Check if there is data for the given gene
        data = {"species": "arabidopsis", "genes": ["AT1G01011"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)

        data = {"species": "poplar", "genes": ["Potri.001G000201"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)

        data = {"species": "tomato", "genes": ["Solyc00g005001"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)

        data = {"species": "soybean", "genes": ["Glyma.01G000101"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)
