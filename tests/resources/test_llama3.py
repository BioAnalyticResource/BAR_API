from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_llama(self):
        """
        This functions tests retrieving llama3 results.
        """

        # Valid request rice
        response = self.app_client.get("/LLaMA/AT3G18850")
        expected = {
            "wasSuccessful": True,
            "data": {
                "summary": "The gene AT3G18850, also known as LPAT5, has been found to localize to the endoplasmic reticulum (ER) (PubMed ID 31211859). This localization is crucial for its function, as LPAT5 is responsible for producing phospholipids and triacylglycerol (TAG) (PubMed ID 31211859).",
                "gene_id": "AT3G18850",
                "bert_score": 0.9839827,
            },
        }
        self.assertEqual(response.json, expected)

        # Gene does not exist
        response = self.app_client.get("/LLaMA/XX3G18850")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)
