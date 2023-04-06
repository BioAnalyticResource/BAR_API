from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_gene_alias_list(self):
        """This function tests the gene sequence endpoint
        :return:
        """
        # Valid request
        response = self.app_client.get("/sequence/tomato/Solyc00g005445.1.1")
        expected = {
            "status": "success",
            "result": [
                {
                    "length": 142,
                    "gene_id": "Solyc00g005445.1.1",
                    "sequence": "MSIFSDKIEDTIEQPTDESRSLMLADNVYIHVLSAYKLWRKYSSKKQTRKIFLLIRKEVHKQIGCQYTGVTLSEWQLEYAKLRVERADLQVVLSFIVLFIATRKDLEEATKVVQEKMIVCRIEACRGVWTKVQEGALESSVI*",
                }
            ],
        }
        self.assertEqual(response.json, expected)

        # Invalid species
        response = self.app_client.get("/sequence/abc/Solyc00g005445.1.1")
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/sequence/Tomato/abc")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # No data
        response = self.app_client.get("/sequence/Tomato/Solyc99g999999.1.1")
        expected = {"wasSuccessful": False, "error": "There are no data found for the given gene"}
        self.assertEqual(response.json, expected)
