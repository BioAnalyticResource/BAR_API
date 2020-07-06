from api import app
from json import load
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_atted_api4(self):
        """
        This tests the data returned by the Atted proxy
        :return:
        """
        # Valid data
        response = self.app_client.get('/proxy/atted_api4/At1g01010/5')
        # Note: pytest is running from project root. So path is relative to project root
        with open('tests/data/get_atted_api4.json') as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

        # Invalid gene
        response = self.app_client.get('/proxy/atted_api4/At1g0101x/5')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid gene id"
        }
        self.assertEqual(response.json, expected)

        # If no data, the service should return this response
        response = self.app_client.get('/proxy/atted_api4/At1g01011/5')

        expected = {
            "error": "No gene ID specified.",
            "status_code": 400
        }
        self.assertEqual(response.json, expected)

        # Invalid topN count
        response = self.app_client.get('proxy/atted_api4/At1g01010/9999999999999999999')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid count"
        }
        self.assertEqual(response.json, expected)
