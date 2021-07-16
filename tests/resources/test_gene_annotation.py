from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_keyword_search(self):
        test_query = "alpha-1 protein"
        response = self.app_client.get(f"/gene_annotation/{test_query}").json
        self.assertEqual(response["status"], "success")
        annotation = response["result"][0]["gene_annotation"]
        self.assertIn(test_query, annotation)
