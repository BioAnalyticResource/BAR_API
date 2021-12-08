from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_efp_image_list(self):
        """This function tests the gene alias list get function
        :return:
        """
        response = self.app_client.get("/efp_image/")
        expected = {"wasSuccessful": True, "data": ["efp_arabidopsis"]}
        self.assertEqual(response.json, expected)

    def test_get_efp_image(self):
        """This function test eFP image endpoint get request
        :return:
        """
        # A very basic test for Arabidopsis requests
        # https://bar.utoronto.ca/api/efp_image/efp_arabidopsis/Developmental_Map/Absolute/At1g01010
        response = self.app_client.get(
            "/efp_image/efp_arabidopsis/Developmental_Map/Absolute/At1g01010"
        )
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, "image/png")
        self.assertEqual(response.content_length, 190879)

        # A very basic test for Arabidopsis requests
        # https://bar.utoronto.ca/api/efp_image/efp_arabidopsis/Developmental_Map/Compare/At1g01010/At1g01030
        response = self.app_client.get(
            "/efp_image/efp_arabidopsis/Developmental_Map/Compare/At1g01010/At1g01030"
        )
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, "image/png")
        self.assertEqual(response.content_length, 193587)

        # Test for invalid species:
        response = self.app_client.get(
            "/efp_image/abc/Developmental_Map/Absolute/At1g01010"
        )
        expected = {"wasSuccessful": False, "error": "Invalid eFP."}
        self.assertEqual(response.json, expected)

        # Test for eFP view name
        response = self.app_client.get(
            "/efp_image/efp_arabidopsis/ab.!c/Absolute/At1g01010"
        )
        expected = {"wasSuccessful": False, "error": "Invalid eFP View name."}
        self.assertEqual(response.json, expected)

        # Test for eFP mode
        response = self.app_client.get("/efp_image/efp_arabidopsis/Root/abc/At1g01010")
        expected = {"wasSuccessful": False, "error": "Invalid eFP mode."}
        self.assertEqual(response.json, expected)

        # Test for gene 1 using Arabidopsis
        response = self.app_client.get(
            "/efp_image/efp_arabidopsis/Root/Absolute/At1g0101X"
        )
        expected = {"wasSuccessful": False, "error": "Gene 1 is invalid."}
        self.assertEqual(response.json, expected)

        response = self.app_client.get(
            "/efp_image/efp_arabidopsis/Developmental_Map/Absolute/At1g01011"
        )
        expected = {
            "wasSuccessful": False,
            "error": "Failed to retrieve image. Data for the given gene may not exist.",
        }
        self.assertEqual(response.json, expected)

        # Test for gene 2 using Arabidopsis
        response = self.app_client.get(
            "/efp_image/efp_arabidopsis/Root/Compare/At1g01010/Abc"
        )
        expected = {"wasSuccessful": False, "error": "Gene 2 is invalid."}
        self.assertEqual(response.json, expected)
