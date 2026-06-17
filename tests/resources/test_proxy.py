from api import app
from json import load
from unittest.mock import MagicMock, patch
import unittest
import requests


class TestIntegrations(unittest.TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_atted_api5(self):
        """This tests the data returned by the Atted proxy
        :return:
        """
        # Valid data
        with open("tests/data/get_atted_api5.json") as json_file:
            expected = load(json_file)

        mock_success = MagicMock()
        mock_success.status_code = 200
        mock_success.json.return_value = expected
        mock_success.raise_for_status.return_value = None

        mock_no_data = MagicMock()
        mock_no_data.status_code = 200
        mock_no_data.json.return_value = {"error": "No gene ID specified.", "status_code": 400}
        mock_no_data.raise_for_status.return_value = None

        with patch("api.resources.proxy.requests.get", side_effect=[mock_success, mock_no_data]):
            response = self.app_client.get("/proxy/atted_api5/At1g01010/5")

            self.assertEqual(response.json, expected)

            # Invalid gene
            response = self.app_client.get("/proxy/atted_api5/At1g0101x/5")
            expected = {"wasSuccessful": False, "error": "Invalid gene id"}
            self.assertEqual(response.json, expected)

            # If no data, the service should return this response
            response = self.app_client.get("/proxy/atted_api5/At1g01011/5")
            expected = {"error": "No gene ID specified.", "status_code": 400}
            self.assertEqual(response.json, expected)

            # Invalid topN count
            response = self.app_client.get("proxy/atted_api5/At1g01010/9999999999999999999")
            expected = {"wasSuccessful": False, "error": "Invalid count"}
            self.assertEqual(response.json, expected)

    def test_get_atted_api5_handles_external_error(self):
        failure_response = MagicMock()
        failure_response.status_code = 403
        http_error = requests.exceptions.HTTPError(response=failure_response)
        failure_response.raise_for_status.side_effect = http_error

        with patch("api.resources.proxy.requests.get", return_value=failure_response):
            response = self.app_client.get("/proxy/atted_api5/At1g01010/5")

        expected = {"wasSuccessful": False, "error": "External API request failed with status code 403"}
        self.assertEqual(response.status_code, 403)
        self.assertEqual(response.json, expected)
