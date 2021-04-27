from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_phenix(self):
        """This function test Phenix.
        I don't have a good way to test this end point. So we assume the pdb file exits on the BAR for now.
        This is disabled for now.
        """

        # Valid request
        response = self.app_client.get("/snps/phenix/Potri.016G107900.1/AT5G01040.1")
        expected = {
            "wasSuccessful": True,
            "data": "//bar.utoronto.ca/phenix-pdbs/POTRI.016G107900.1-AT5G01040.1-phenix.pdb",
        }
        self.assertEqual(response.json, expected)

        # Valid request
        response = self.app_client.get("/snps/phenix/AT5G01040.1/Potri.016G107900.1")
        expected = {
            "wasSuccessful": True,
            "data": "//bar.utoronto.ca/phenix-pdbs/AT5G01040.1-POTRI.016G107900.1-phenix.pdb",
        }
        self.assertEqual(response.json, expected)

        # Invalid fixed gene
        response = self.app_client.get("/snps/phenix/abc/AT5G01040.1")
        expected = {"wasSuccessful": False, "error": "Invalid fixed pdb gene id"}
        self.assertEqual(response.json, expected)

        # Invalid moving gene
        response = self.app_client.get("/snps/phenix/Potri.016G107900.1/abc")
        expected = {"wasSuccessful": False, "error": "Invalid moving pdb gene id"}
        self.assertEqual(response.json, expected)

    def test_get_gene_alias(self):
        """This function test gene alias.
        Note: This is using proof of principle database with only one row. Testing on the BAR will fail for now.
        """

        # Valid request poplar
        response = self.app_client.get("/snps/poplar/Potri.019G123900.1")
        expected = {
            "wasSuccessful": True,
            "data": [
                [
                    19,
                    126,
                    "KTMA-12-1",
                    "missense_variant",
                    "MODERATE",
                    "MISSENSE",
                    "380C>A",
                    "AlaAsp",
                    None,
                    "Potri.019G123900",
                    "protein_coding",
                    "CODING",
                    "Potri.019G123900.1",
                    None,
                ]
            ],
        }
        self.assertEqual(response.json, expected)

        # Valid request tomato
        response = self.app_client.get("/snps/tomato/Solyc00g005060.1.1")
        expected = {
            "wasSuccessful": True,
            "data": [
                [
                    0,
                    51,
                    "001",
                    "missense_variant",
                    "MODERATE",
                    "MISSENSE",
                    "154T>G",
                    "TrpGly",
                    None,
                    "Solyc00g005060.1",
                    "protein_coding",
                    "CODING",
                    "Solyc00g005060.1.1",
                    None
                ]
            ],
        }
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/snps/poplar/abc")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Gene does not exist
        response = self.app_client.get("/snps/poplar/Potri.019G123901.1")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)
