from api.base import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app = app.test_client()

    def test_arabidopsis_gene_alias(self):
        """
        This tests check for a gene alias for the Arabidopsis gene ABI3
        :return:
        """
        response = self.app.get('/gene_alias/arabidopsis/At3g24650')
        expected = {"status": "success", "alias": ["ABI3", "AtABI3", "SIS10"]}
        self.assertEqual(response.json, expected)
