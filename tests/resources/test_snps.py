from api import app
from unittest import TestCase
import pytest
from json import load


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    @pytest.mark.skip(reason="Changed data infrastructure of holding PDB files, links no longer work")
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

        # Valid request canola
        response = self.app_client.get("/snps/canola/BnaC09g12790D")
        expected = {
            "wasSuccessful": True,
            "data": [
                [
                    "chrC09",
                    22,
                    None,
                    "missense_variant",
                    "MODERATE",
                    "MISSENSE",
                    "67C>A",
                    "ValPhe",
                    None,
                    "BnaC09g12790D",
                    "protein_coding",
                    "CODING",
                    "GSBRNA2T00000007001",
                    0.0066,
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

        # Invalid gene id for canola
        response = self.app_client.get("/snps/canola/abc")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Gene does not exist for canola
        response = self.app_client.get("/snps/canola/BnaC07g99930D")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

    def test_get_sample_definitions(self):
        """
        Test cases for sample definition
        """
        # Tomato
        response = self.app_client.get("/snps/tomato/samples")
        expected = {"wasSuccessful": True, "data": {"001": {"alias": "Moneymaker", "species": "Solanum lycopersicum"}}}
        self.assertEqual(response.json, expected)

        # Soybean
        response = self.app_client.get("/snps/soybean/samples")
        expected = {
            "wasSuccessful": True,
            "data": {
                "Gm_H002": {"dataset": "Torkamaneh_Laroche_2019", "PI number": "X5302-1-52-3-2-B"},
                "Gm_H003": {"dataset": "Torkamaneh_Laroche_2019", "PI number": "OACInwood"},
                "Gm_H004": {"dataset": "Torkamaneh_Laroche_2019", "PI number": "OACDrayton"},
            },
        }
        self.assertEqual(response.json, expected)

        # Invalid
        response = self.app_client.get("/snps/abc/samples")
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(response.json, expected)

    @pytest.mark.pymolneeded
    def test_pymol_snps(self):
        """
        Test for class of Pymol:
        test_1: valid input + successful response
        test_2: valid input + ignore cases + repeated identical SNP string
        test_3: invalid input for snps + incorrect locus
        test_4: invalid input for snps + incorrect residue name
        test_5: invalid input for snps + conflict strings
        test_6: invalid input for chain
        """

        # test_1: valid input + successful response
        response = self.app_client.get("/snps/pymol/Potri.016G107900.1?snps=V25L&snps=E26A&chain=None")
        expected = {
            "wasSuccessful": True,
            "data": "//bar.utoronto.ca/pymol-mutated-pdbs/POTRI.016G107900.1-V25L-E26A.pdb",
        }
        self.assertEqual(response.json, expected)

        # test_2: valid input + ignore cases + repeated identical SNP string
        response = self.app_client.get("/snps/pymol/Potri.016G107900.1?snps=V25L&snps=v25l&chain=None")
        expected = {
            "wasSuccessful": True,
            "data": "//bar.utoronto.ca/pymol-mutated-pdbs/POTRI.016G107900.1-V25L.pdb",
        }
        self.assertEqual(response.json, expected)

        # test_3: invalid input for snps + incorrect locus
        response = self.app_client.get("/snps/pymol/Potri.016G107900.1?snps=V1L&chain=None")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid SNP input range, see locus 1; residues range start from 24(I) to 569(C)",
        }
        self.assertEqual(response.json, expected)

        # test_4: invalid input for snps + incorrect residue name
        response = self.app_client.get("/snps/pymol/Potri.016G107900.1?snps=K25L&chain=None")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid SNP residue, residue 25 of the model is V",
        }
        self.assertEqual(response.json, expected)

        # test_5: invalid input for snps + conflict strings
        response = self.app_client.get("/snps/pymol/Potri.016G107900.1?snps=V25L&snps=V25A&chain=None")
        expected = {
            "wasSuccessful": False,
            "error": "Conflict SNPs input at loci: [25]",
        }
        self.assertEqual(response.json, expected)

        # test_6: invalid input for chain
        response = self.app_client.get("/snps/pymol/Potri.016G107900.1?snps=V25L&chain=A")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid chain input, the model is monomer",
        }
        self.assertEqual(response.json, expected)

    def test_pymol_snps_pymol_unneeded(self):
        """This function test our Pymol endpoint for where Pymol is not needed to be installed.
        These unit-tests will thus run on local environments and CI, regardless of Pymol.
        test_1: invalid input for gene name
        test_2: invalid input for snps + incorrect protein letter code
        test_3: invalid input for snps + incorrect format
        """
        # test_1: invalid input for gene name
        response = self.app_client.get("/snps/pymol/aaa?snps=V25L&chain=None")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # test_2: invalid input for snps + incorrect protein letter code
        response = self.app_client.get("/snps/pymol/Potri.016G107900.1?snps=B25A&chain=None")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid SNP string for protein letters",
        }
        self.assertEqual(response.json, expected)

        # test_3: invalid input for snps + incorrect format
        response = self.app_client.get("/snps/pymol/Potri.016G107900.1?snps=25l&chain=None")
        expected = {"wasSuccessful": False, "error": "Invalid SNP string format"}
        self.assertEqual(response.json, expected)

    def test_homologs(self):

        # test for get homologs
        response = self.app_client.get("/snps/homologs/arabidopsis/AT5G16970.1/canola")
        with open("tests/data/get_canola_homolog_information.json") as file:
            expected = load(file)
        self.assertEqual(response.json, expected)

        # test for invalid input
        response = self.app_client.get("/snps/homologs/rice/AT3G18710.1/canola")
        expected = {
            "wasSuccessful": False,
            "error": "Species not supported",
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/snps/homologs/arabidopsis/AT3G18710.1/rice")
        expected = {
            "wasSuccessful": False,
            "error": "Species not supported",
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/snps/homologs/arabidopsis/abc/canola")
        expected = {
            "wasSuccessful": False,
            "error": "Invalid gene id",
        }
        self.assertEqual(response.json, expected)

        # test for no homologs data
        response = self.app_client.get("/snps/homologs/arabidopsis/AT3G18710.1/canola")
        expected = {
            "wasSuccessful": False,
            "error": "No homologs found for the given query",
        }
        self.assertEqual(response.json, expected)
