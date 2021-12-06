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
