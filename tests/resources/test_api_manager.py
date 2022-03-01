from api import app
from unittest import TestCase
import json


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_validate_admin_password(self):
        # Invalid password
        response = self.app_client.post(
            "/api_manager/validate_admin_password", json={"password": "abc"}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": True, "data": False}
        self.assertEqual(data, expected)

    def test_validate_api_key(self):
        # Valid API key
        response = self.app_client.post(
            "/api_manager/validate_api_key",
            json={"key": "bb5a52387069485486b2f4861c2826dd"},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": True, "data": True}
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

        # Invalid API key
        response = self.app_client.post(
            "/api_manager/validate_api_key",
            json={"key": "abc"},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "API key not found"}
        self.assertEqual(response.status_code, 404)
        self.assertEqual(data, expected)

    def test_request(self):
        # testPassword set in the test config
        response = self.app_client.post(
            "/api_manager/request",
            json={
                "first_name": "Unit",
                "last_name": "Test",
                "email": "unittest@gmail.com",
                "notes": "Unit test notes.",
            },
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": True, "data": "Data added"}
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_get_pending_requests(self):
        # Password is correct
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
                    "notes": "Test notes",
                },
                {
                    "first_name": "Unit",
                    "last_name": "Test",
                    "email": "unittest@gmail.com",
                    "notes": "Unit test notes.",
                },
            ],
        }
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

        # Password is not correct
        response = self.app_client.post(
            "/api_manager/get_pending_requests", json={"password": "abc"}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Forbidden"}
        self.assertEqual(response.status_code, 403)
        self.assertEqual(data, expected)

    def test_reject_request(self):
        # Correct password
        response = self.app_client.post(
            "/api_manager/reject_request",
            json={"password": "testPassword", "email": "unittest@gmail.com"},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": True, "data": True}
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

        # Incorrect password
        response = self.app_client.post(
            "/api_manager/reject_request",
            json={"password": "abc", "email": "unittest@gmail.com"},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Forbidden"}
        self.assertEqual(response.status_code, 403)
        self.assertEqual(data, expected)
