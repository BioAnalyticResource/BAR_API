from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_bands(self):
        """This function checks GET request for fastpheno bands
        :return:
        """
        response = self.app_client.get("/fastpheno/get_bands/pintendre/feb/band_1")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "site_name": "Pintendre",
                    "tree_id": 1,
                    "longitude": 336839,
                    "latitutde": 5178557,
                    "genotype_id": "C",
                    "tree_given_id": "11",
                    "external_link": "example",
                    "band_value": 0.025796278,
                    "tree_height_proxy": 3.478942871,
                    "ground_height_proxy": 49.10671997,
                    "band_month": "feb",
                },
                {
                    "site_name": "Pintendre",
                    "tree_id": 2,
                    "longitude": 336872,
                    "latitutde": 5178486,
                    "genotype_id": "C",
                    "tree_given_id": "11",
                    "external_link": "example2",
                    "band_value": 0.183586478,
                    "tree_height_proxy": 2.383630037,
                    "ground_height_proxy": 48.12341242131163,
                    "band_month": "feb",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        # Not working version
        response = self.app_client.get("/fastpheno/get_bands/NOTASITE/feb/band_1")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given parameters",
        }
        self.assertEqual(response.json, expected)

        # Invalid site
        response = self.app_client.get("/fastpheno/get_bands/12345/feb/band_1")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid site name",
        }
        self.assertEqual(response.json, expected)

        # Invalid month
        response = self.app_client.get("/fastpheno/get_bands/pintendre/1234/band_1")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid month",
        }
        self.assertEqual(response.json, expected)

        # Invalid band
        response = self.app_client.get("/fastpheno/get_bands/NOTASITE/feb/band_x")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid band",
        }
        self.assertEqual(response.json, expected)

    def test_site_genotype_ids(self):
        """This function checks GET request for fastpheno sites for genotype_ids
        :return:
        """
        response = self.app_client.get("/fastpheno/get_trees/C")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "site_name": "Pintendre",
                    "tree_id": 1,
                    "longitude": 336839,
                    "latitutde": 5178557,
                    "genotype_id": "C",
                    "tree_given_id": "11",
                    "external_link": "example",
                },
                {
                    "site_name": "Pintendre",
                    "tree_id": 2,
                    "longitude": 336872,
                    "latitutde": 5178486,
                    "genotype_id": "C",
                    "tree_given_id": "11",
                    "external_link": "example2",
                },
                {
                    "site_name": "Pintendre",
                    "tree_id": 3,
                    "longitude": 346872,
                    "latitutde": 5278486,
                    "genotype_id": "C",
                    "tree_given_id": "B",
                    "external_link": "example3",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        # Not working version
        response = self.app_client.get("/fastpheno/get_trees/Z")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given parameters",
        }
        self.assertEqual(response.json, expected)

        # Invalid data
        response = self.app_client.get("/fastpheno/get_trees/NOTVALID")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid genotype id",
        }
        self.assertEqual(response.json, expected)
