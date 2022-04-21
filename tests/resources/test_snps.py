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

    def test_get_snps(self):
        """This function will test retrieving SNPs for several supported species.
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
                    None,
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

    def test_pymol_snps(self):
        """
        Test for class of Pymol:
        test_1: valid input + successful response
        test_2: valid input + ignore cases + repeated identical SNP string
        test_3: invalid input for gene name
        test_4: invalid input for snps + incorrect protein letter code
        test_5: invalid input for snps + incorrect format
        test_6: invalid input for snps + incorrect locus
        test_7: invalid input for snps + incorrect residue name
        test_8: invalid input for snps + conflict strings
        test_9: invalid input for chain
        """

        # test_1: valid input + successful response
        response = self.app_client.get("/snps/pymol?model=Potri.016G107900.1&snps=V25L&snps=E26A&chain=None")
        expected = {"wasSuccessful": True,
                    "data": "//bar.utoronto.ca/pymol-mutated-pdbs/POTRI.016G107900.1-V25L-E26A.pdb"}
        self.assertEqual(response.json, expected)

        # test_2: valid input + ignore cases + repeated identical SNP string
        response = self.app_client.get("/snps/pymol?model=Potri.016G107900.1&snps=V25L&snps=v25l&chain=None")
        expected = {"wasSuccessful": True,
                    "data": "//bar.utoronto.ca/pymol-mutated-pdbs/POTRI.016G107900.1-V25L.pdb"}
        self.assertEqual(response.json, expected)

        # test_3: invalid input for gene name
        response = self.app_client.get("/snps/pymol?model=aaa&snps=V25L&chain=None")
        expected = {"wasSuccessful": False,
                    "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # test_4: invalid input for snps + incorrect protein letter code
        response = self.app_client.get("/snps/pymol?model=Potri.016G107900.1&snps=B25A&chain=None")
        expected = {"wasSuccessful": False,
                    "error": "Invalid SNP string for protein letters"}
        self.assertEqual(response.json, expected)

        # test_5: invalid input for snps + incorrect format
        response = self.app_client.get("/snps/pymol?model=Potri.016G107900.1&snps=25l&chain=None")
        expected = {"wasSuccessful": False,
                    "error": "Invalid SNP string format"}
        self.assertEqual(response.json, expected)

        # test_6: invalid input for snps + incorrect locus
        response = self.app_client.get("/snps/pymol?model=Potri.016G107900.1&snps=V1L&chain=None")
        expected = {"wasSuccessful": False,
                    "error": "Invalid SNP input, locus 1 out of range, residues range start from 24(I) to 569(C)"}
        self.assertEqual(response.json, expected)

        # test_7: invalid input for snps + incorrect residue name
        response = self.app_client.get("/snps/pymol?model=Potri.016G107900.1&snps=K25L&chain=None")
        expected = {"wasSuccessful": False,
                    "error": "Invalid SNP input, residue 25 of the model is V"}
        self.assertEqual(response.json, expected)

        # test_8: invalid input for snps + conflict strings
        response = self.app_client.get("/snps/pymol?model=Potri.016G107900.1&snps=V25L&snps=V25A&chain=None")
        expected = {"wasSuccessful": False,
                    "error": "Conflict SNPs input at loci: [25]"}
        self.assertEqual(response.json, expected)

        # test_9: invalid input for chain
        response = self.app_client.get("/snps/pymol?model=Potri.016G107900.1&snps=V25L&chain=A")
        expected = {"wasSuccessful": False,
                    "error": "Invalid chain input, the model is monomer"}
        self.assertEqual(response.json, expected)
