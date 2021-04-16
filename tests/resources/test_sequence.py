from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_gene_alias_list(self):
        """This function tests the gene sequence endpoint
        :return:
        """
        response = self.app_client.get("/sequence/tomato/Solyc00g005445.1.1")
        expected = {
            "gene_id": "Solyc00g005445.1.1",
            "sequence": "MSIFSDKIEDTIEQPTDESRSLMLADNVYIHVLSAYKLWRKYSSKKQTRKIFLLIRKEVHKQIGCQYTGVTLSEWQLEYAKLRVERADLQVVLSFIVLFIATRKDLEEATKVVQEKMIVCRIEACRGVWTKVQEGALESSVI*",
            "length": 143,
            "phyre_2_seq": "KEVHKQIGCQYTGVTLSEWQLEYAKLRVERADLQVVLSFIVLFIATRKDLEEATKVVQEKMIVCRIEA",
            "phyre2_seq_start": 57,
            "phyre2_seq_end": 124
        }
        self.assertEqual(response.json, expected)
