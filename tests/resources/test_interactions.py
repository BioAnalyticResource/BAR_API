from api import app
from unittest import TestCase


class TestIntegrations(TestCase):

    maxDiff = None

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
          "data" :
          [
              {
                "protein_1": "LOC_Os01g01080",
                "protein_2": "LOC_Os01g52560",
                "total_hits": 1,
                "Num_species": 1,
                "Quality": 1,
                "pcc": 0.65
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
        self.assertEqual(response.json, expected)

        # Invalid species
        response = self.app_client.get("/interactions/poplar/abc")
        expected = {
          "wasSuccessful": False,
          "error": "Invalid species or gene ID"
        }
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/interactions/rice/abc")
        expected = {
          "wasSuccessful": False,
          "error": "Invalid species or gene ID"
        }
        self.assertEqual(response.json, expected)

        # Gene does not exist
        response = self.app_client.get("/interactions/rice/LOC_Os01g52565")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)
