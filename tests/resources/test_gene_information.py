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

    def test_get_arabidopsis_gene_isoform(self):
        """This tests checks GET request for gene isoforms Arabidopsis
        :return:
        """
        # Valid data
        response = self.app_client.get('/gene_information/gene_isoforms/arabidopsis/AT1G01020')
        expected = {
            "wasSuccessful": True,
            "data": [
                "AT1G01020.1",
                "AT1G01020.2"
            ]
        }
        self.assertEqual(response.json, expected)

        # Data not found, but gene is valid
        response = self.app_client.get('/gene_information/gene_isoforms/arabidopsis/At3g24651')
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene"
        }
        self.assertEqual(response.json, expected)

        # Invalid Gene
        response = self.app_client.get('/gene_information/gene_isoforms/arabidopsis/At3g2465x')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid gene id"
        }
        self.assertEqual(response.json, expected)

        # Invalid Species
        response = self.app_client.get('/gene_information/gene_isoforms/x/At3g24650')
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species"
        }
        self.assertEqual(response.json, expected)

    def test_post_arabidopsis_gene_isoform(self):
        """This tests the data returned for Arabidopsis gene isoforms.
        :return:
        """
        # Valid example
        data = {
            "species": "arabidopsis",
            "genes": [
                "AT1G01010",
                "AT1G01020"
            ]
        }
        response = self.app_client.post('/gene_information/gene_isoforms/', json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01010": [
                    "AT1G01010.1"
                ],
                "AT1G01020": [
                    "AT1G01020.1",
                    "AT1G01020.2"
                ]
            }
        }
        self.assertEqual(response.json, expected)

        # Invalid data in JSON
        data = {
            "species": "arabidopsis",
            "genes": [
                "AT1G01010",
                "AT1G01020"
            ],
            "abc": "xyz"
        }
        response = self.app_client.post('/gene_information/gene_isoforms/', json=data)
        expected = {'wasSuccessful': False, 'error': {'abc': ['Unknown field.']}}
        self.assertEqual(response.json, expected)

        # Data not found for a valid gene
        data = {
            "species": "arabidopsis",
            "genes": [
                "AT1G01011",
                "AT1G01020"
            ]
        }
        response = self.app_client.post('/gene_information/gene_isoforms/', json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01020": [
                    "AT1G01020.1",
                    "AT1G01020.2"
                ]
            }
        }
        self.assertEqual(response.json, expected)

        # Check if arabidopsis gene is valid
        data = {
            "species": "arabidopsis",
            "genes": [
                "AT1G01011",
                "AT1G01020"
            ]
        }
        response = self.app_client.post('/gene_information/gene_isoforms/', json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01020": [
                    "AT1G01020.1",
                    "AT1G01020.2"
                ]
            }
        }
        self.assertEqual(response.json, expected)

        # Check if gene is valid
        data = {
            "species": "arabidopsis",
            "genes": [
                "abc"
            ]
        }
        response = self.app_client.post('/gene_information/gene_isoforms/', json=data)
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Check if there is data for the given gene
        data = {
            "species": "arabidopsis",
            "genes": [
                "AT1G01011"
            ]
        }
        response = self.app_client.post('/gene_information/gene_isoforms/', json=data)
        expected = {"wasSuccessful": False, "error": "No data for the given species/genes"}
        self.assertEqual(response.json, expected)

        # Check if species is valid
        data = {
            "species": "abc",
            "genes": [
                "AT1G01010",
                "AT1G01020"
            ]
        }
        response = self.app_client.post('/gene_information/gene_isoforms/', json=data)
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(response.json, expected)

        # Check if there is data for the given gene
        data = {
            "species": "arabidopsis",
            "genes": [
                "AT1G01011"
            ]
        }
        response = self.app_client.post('/gene_information/gene_isoforms/', json=data)
        expected = {"wasSuccessful": False, "error": "No data for the given species/genes"}
        self.assertEqual(response.json, expected)
