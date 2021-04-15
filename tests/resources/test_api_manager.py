from api import app
from unittest import TestCase
import json


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_0_validate_api_key(self):
        response = self.app_client.post(
            "/api_manager/validate_api_key",
            json={"key": "bb5a52387069485486b2f4861c2826dd"},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": True, "data": True}
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_1_request(self):
        # testPassword set in the test config
        response = self.app_client.post(
            "/api_manager/request",
            json={
                "first_name": "Unit",
                "last_name": "Test",
                "email": "unittest@gmail.com",
                "telephone": "1234567890",
                "contact_type": "Phone",
                "notes": "Unit test notes.",
            },
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": True, "data": "Data added, email failed"}
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_2_get_pending_requests(self):
        response = self.app_client.post(
            "/api_manager/get_pending_requests", json={"password": "testPassword"}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "first_name": "Some",
                    "last_name": "Request",
                    "email": "request@gmail.com",
                    "telephone": "1234567890",
                    "contact_type": "Phone",
                    "notes": "Test notes",
                },
                {
                    "first_name": "Unit",
                    "last_name": "Test",
                    "email": "unittest@gmail.com",
                    "telephone": "1234567890",
                    "contact_type": "Phone",
                    "notes": "Unit test notes.",
                },
            ],
        }
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_3_reject_request(self):
        response = self.app_client.post(
            "/api_manager/reject_request",
            json={"password": "testPassword", "email": "unittest@gmail.com"},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": True, "data": True}
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)
