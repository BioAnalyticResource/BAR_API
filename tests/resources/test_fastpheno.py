from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_bands(self):
        """Tests GET /fastpheno/get_bands/<site>/<flight_id>/<band>"""
        response = self.app_client.get("/fastpheno/get_bands/Pintendre/14/398nm")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "trees_pk": 1,
                    "seq_id": "PIN_2547",
                    "longitude": -71.134606710951,
                    "latitude": 46.740492838807,
                    "x_pos": 38,
                    "y_pos": 68,
                    "height_2022": "-1",
                    "block_num": 6,
                    "tree_site_id": "c",
                    "confidence": 0.99769,
                    "band_value": 0.07344,
                },
                {
                    "trees_pk": 2,
                    "seq_id": "PIN_1301",
                    "longitude": -71.134693444446,
                    "latitude": 46.739706272423,
                    "x_pos": 9,
                    "y_pos": 35,
                    "height_2022": "210",
                    "block_num": 5,
                    "tree_site_id": "127.07",
                    "confidence": 0.99831,
                    "band_value": 0.03096,
                },
                {
                    "trees_pk": 3,
                    "seq_id": "PIN_2970",
                    "longitude": -71.133814526723,
                    "latitude": 46.74021986852,
                    "x_pos": 6,
                    "y_pos": 79,
                    "height_2022": "273",
                    "block_num": 6,
                    "tree_site_id": "619.03",
                    "confidence": 0.99856,
                    "band_value": 0.03606,
                },
                {
                    "trees_pk": 2260,
                    "seq_id": "PIN_2260",
                    "longitude": -71.13311060453,
                    "latitude": 46.741369741463,
                    "x_pos": 33,
                    "y_pos": 143,
                    "height_2022": "300",
                    "block_num": 7,
                    "tree_site_id": "619.02",
                    "confidence": 0.99654,
                    "band_value": 0.03531,
                },
                {
                    "trees_pk": 5384,
                    "seq_id": "PIN_2025",
                    "longitude": -71.134685695396,
                    "latitude": 46.740188723522,
                    "x_pos": 28,
                    "y_pos": 54,
                    "height_2022": "410",
                    "block_num": 7,
                    "tree_site_id": "619.12",
                    "confidence": 0.9984,
                    "band_value": 0.03913,
                },
            ],
        }
        self.assertEqual(response.json, expected)

        # No data for valid params
        response = self.app_client.get("/fastpheno/get_bands/Pickering/14/398nm")
        expected = {"wasSuccessful": False, "error": "No data found for the given parameters"}
        self.assertEqual(response.json, expected)

        # Invalid site name (numeric)
        response = self.app_client.get("/fastpheno/get_bands/12345/14/398nm")
        expected = {"wasSuccessful": False, "error": "Invalid site name"}
        self.assertEqual(response.json, expected)

        # Invalid flight ID (not an integer)
        response = self.app_client.get("/fastpheno/get_bands/Pintendre/abc/398nm")
        expected = {"wasSuccessful": False, "error": "Invalid flight ID"}
        self.assertEqual(response.json, expected)

        # Invalid band (special characters)
        response = self.app_client.get("/fastpheno/get_bands/Pintendre/14/398!nm")
        expected = {"wasSuccessful": False, "error": "Invalid band"}
        self.assertEqual(response.json, expected)

    def test_get_trees(self):
        """Tests GET /fastpheno/get_trees/<tree_site_id>"""
        response = self.app_client.get("/fastpheno/get_trees/619")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "site_name": "Pintendre",
                    "trees_pk": 3,
                    "seq_id": "PIN_2970",
                    "longitude": -71.133814526723,
                    "latitude": 46.74021986852,
                    "tree_site_id": "619.03",
                    "external_link": None,
                },
                {
                    "site_name": "Pintendre",
                    "trees_pk": 2260,
                    "seq_id": "PIN_2260",
                    "longitude": -71.13311060453,
                    "latitude": 46.741369741463,
                    "tree_site_id": "619.02",
                    "external_link": None,
                },
                {
                    "site_name": "Pintendre",
                    "trees_pk": 5384,
                    "seq_id": "PIN_2025",
                    "longitude": -71.134685695396,
                    "latitude": 46.740188723522,
                    "tree_site_id": "619.12",
                    "external_link": None,
                },
            ],
        }
        self.assertEqual(response.json, expected)

        # With optional site filter
        response = self.app_client.get("/fastpheno/get_trees/619?site=Pintendre")
        self.assertEqual(response.json, expected)

        # No data for valid genotype not in DB
        response = self.app_client.get("/fastpheno/get_trees/9999")
        expected = {"wasSuccessful": False, "error": "No data found for the given parameters"}
        self.assertEqual(response.json, expected)

        # No data for valid genotype but wrong site
        response = self.app_client.get("/fastpheno/get_trees/619?site=Pickering")
        expected = {"wasSuccessful": False, "error": "No data found for the given parameters"}
        self.assertEqual(response.json, expected)

        # Invalid tree_site_id (contains disallowed character)
        response = self.app_client.get("/fastpheno/get_trees/619!")
        expected = {"wasSuccessful": False, "error": "Invalid tree site ID"}
        self.assertEqual(response.json, expected)

        # Invalid site param (special characters)
        response = self.app_client.get("/fastpheno/get_trees/619?site=123")
        expected = {"wasSuccessful": False, "error": "Invalid site name"}
        self.assertEqual(response.json, expected)

    def test_timeseries_tree(self):
        """Tests GET /fastpheno/timeseries/tree/<seq_id>/<band>"""
        response = self.app_client.get("/fastpheno/timeseries/tree/PIN_2547/398nm")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "flight_date": "2022-06-10T00:00:00",
                    "flights_pk": 14,
                    "confidence": 0.99769,
                    "band_value": 0.07344,
                },
                {
                    "flight_date": "2022-07-16T00:00:00",
                    "flights_pk": 15,
                    "confidence": 0.99823,
                    "band_value": 0.04504,
                },
            ],
        }
        self.assertEqual(response.json, expected)

        # No data for valid tree with no band match
        response = self.app_client.get("/fastpheno/timeseries/tree/PIN_2547/999nm")
        expected = {"wasSuccessful": False, "error": "No data found for the given parameters"}
        self.assertEqual(response.json, expected)

        # Invalid seq_id format
        response = self.app_client.get("/fastpheno/timeseries/tree/NOTVALID/398nm")
        expected = {"wasSuccessful": False, "error": "Invalid seq_id"}
        self.assertEqual(response.json, expected)

        # Invalid band
        response = self.app_client.get("/fastpheno/timeseries/tree/PIN_2547/398!nm")
        expected = {"wasSuccessful": False, "error": "Invalid band"}
        self.assertEqual(response.json, expected)

    def test_timeseries_genotype_aggregate(self):
        """Tests GET /fastpheno/timeseries/genotype/<tree_site_id>/<band>/aggregate"""
        response = self.app_client.get("/fastpheno/timeseries/genotype/619/398nm/aggregate")
        self.assertTrue(response.json["wasSuccessful"])
        self.assertEqual(len(response.json["data"]), 1)
        row = response.json["data"][0]
        self.assertEqual(row["flight_date"], "2022-06-10T00:00:00")
        self.assertEqual(row["flights_pk"], 14)
        self.assertEqual(row["n_trees"], 3)
        self.assertAlmostEqual(row["avg_value"], 0.036833333, places=7)
        self.assertAlmostEqual(row["std_value"], 0.0016526006441027672, places=12)

        # With site filter
        response = self.app_client.get("/fastpheno/timeseries/genotype/619/398nm/aggregate?site=Pintendre")
        self.assertEqual(response.json["wasSuccessful"], True)
        self.assertEqual(len(response.json["data"]), 1)

        # No data when site has no matching trees
        response = self.app_client.get("/fastpheno/timeseries/genotype/619/398nm/aggregate?site=Pickering")
        expected = {"wasSuccessful": False, "error": "No data found for the given parameters"}
        self.assertEqual(response.json, expected)

        # No data for valid but non-existent genotype
        response = self.app_client.get("/fastpheno/timeseries/genotype/9999/398nm/aggregate")
        expected = {"wasSuccessful": False, "error": "No data found for the given parameters"}
        self.assertEqual(response.json, expected)

        # Invalid tree_site_id (contains disallowed character)
        response = self.app_client.get("/fastpheno/timeseries/genotype/619!/398nm/aggregate")
        expected = {"wasSuccessful": False, "error": "Invalid tree site ID"}
        self.assertEqual(response.json, expected)

        # Invalid band
        response = self.app_client.get("/fastpheno/timeseries/genotype/619/398!nm/aggregate")
        expected = {"wasSuccessful": False, "error": "Invalid band"}
        self.assertEqual(response.json, expected)

        # Invalid site name
        response = self.app_client.get("/fastpheno/timeseries/genotype/619/398nm/aggregate?site=123")
        expected = {"wasSuccessful": False, "error": "Invalid site name"}
        self.assertEqual(response.json, expected)

    def test_sites(self):
        """Tests GET /fastpheno/sites"""
        response = self.app_client.get("/fastpheno/sites")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "sites_pk": 2,
                    "site_name": "Pickering",
                    "lat": 43.976084584507,
                    "lng": -79.155886757746,
                    "site_desc": "Pickering site",
                },
                {
                    "sites_pk": 1,
                    "site_name": "Pintendre",
                    "lat": 46.740374307111,
                    "lng": -71.134103487947,
                    "site_desc": "Pintendre site",
                },
            ],
        }
        self.assertEqual(response.json, expected)

    def test_flights(self):
        """Tests GET /fastpheno/flights/<sites_pk>"""
        response = self.app_client.get("/fastpheno/flights/1")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "flights_pk": 14,
                    "flight_date": "2022-06-10T00:00:00",
                    "pilot": None,
                    "height": None,
                    "speed": None,
                },
                {
                    "flights_pk": 15,
                    "flight_date": "2022-07-16T00:00:00",
                    "pilot": None,
                    "height": None,
                    "speed": None,
                },
            ],
        }
        self.assertEqual(response.json, expected)

        # No flights for a valid but empty site
        response = self.app_client.get("/fastpheno/flights/2")
        expected = {"wasSuccessful": False, "error": "No flights found for the given site"}
        self.assertEqual(response.json, expected)

    def test_bands_available(self):
        """Tests GET /fastpheno/bands/available/<flights_pk>"""
        response = self.app_client.get("/fastpheno/bands/available/14")
        expected = {
            "wasSuccessful": True,
            "data": ["398nm", "400nm", "402nm", "405nm", "407nm", "409nm", "411nm", "414nm", "416nm", "1002nm"],
        }
        self.assertEqual(response.json, expected)

        # No bands for a non-existent flight
        response = self.app_client.get("/fastpheno/bands/available/999")
        expected = {"wasSuccessful": False, "error": "No bands found for the given flight"}
        self.assertEqual(response.json, expected)
