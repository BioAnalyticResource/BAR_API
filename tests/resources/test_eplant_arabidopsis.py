"""
Reena Obmina | BCB330 Project 2025-2026 | University of Toronto

Tests for the ePlant Arabidopsis expression endpoint.

Route: GET /expression/ePlant_expression?gene=AT1G01010&species=Arabidopsis

The external plantefp.cgi call inside get_expression() is mocked so tests
run without a network connection to bar.utoronto.ca.

Usage::

    python3 -m pytest tests/resources/test_eplant_arabidopsis.py -v
"""
from api import app
from unittest import TestCase
from unittest.mock import patch

_MOCK_RESULT = {
    "gene": "AT1G01010",
    "views": {
        "atgenexpress": {
            "groups": [
                {
                    "name": "CTRL_7",
                    "controls": {"ATGE_CTRL_7": 13.05},
                    "tissues": [
                        {
                            "name": "Root",
                            "id": "Root",
                            "samples": {"ATGE_9_A": 45.35, "ATGE_9_B": 55.0},
                        }
                    ],
                }
            ]
        }
    },
}


class TestEPlantArabidopsisExpression(TestCase):
    def setUp(self):
        self.client = app.test_client()

    @patch("api.resources.expression.get_expression", return_value=_MOCK_RESULT)
    def test_valid_request(self, _mock):
        response = self.client.get("/expression/ePlant_expression?gene=AT1G01010&species=Arabidopsis")
        self.assertEqual(response.status_code, 200)
        data = response.json
        self.assertTrue(data["wasSuccessful"])
        self.assertEqual(data["data"]["gene"], "AT1G01010")
        self.assertIn("views", data["data"])
        _mock.assert_called_once_with("AT1G01010")

    @patch("api.resources.expression.get_expression", return_value=_MOCK_RESULT)
    def test_gene_uppercased(self, _mock):
        """Gene IDs are normalised to uppercase before being forwarded."""
        self.client.get("/expression/ePlant_expression?gene=at1g01010&species=Arabidopsis")
        _mock.assert_called_once_with("AT1G01010")

    @patch("api.resources.expression.get_expression", return_value=_MOCK_RESULT)
    def test_species_case_insensitive(self, _mock):
        response = self.client.get("/expression/ePlant_expression?gene=AT1G01010&species=arabidopsis")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json["wasSuccessful"])

    @patch("api.resources.expression.get_expression", return_value=_MOCK_RESULT)
    def test_arabidopsis_thaliana_species(self, _mock):
        response = self.client.get(
            "/expression/ePlant_expression?gene=AT1G01010&species=Arabidopsis+thaliana"
        )
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json["wasSuccessful"])

    def test_missing_gene(self):
        response = self.client.get("/expression/ePlant_expression?species=Arabidopsis")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.json["wasSuccessful"])

    def test_invalid_gene(self):
        response = self.client.get("/expression/ePlant_expression?gene=NOTAGENEID&species=Arabidopsis")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.json["wasSuccessful"])

    def test_invalid_species(self):
        response = self.client.get("/expression/ePlant_expression?gene=AT1G01010&species=potato")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.json["wasSuccessful"])
