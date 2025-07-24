from api import app
from unittest import TestCase
from json import load


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_arabidopsis_single_cell_gene(self):
        """This tests the data returned by the RNA-Seq end point
        :return:
        """
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/arabidopsis/single_cell/At1g01010")
        # Note: pytest is running from project root. So path is relative to project root
        with open("tests/data/get_arabidopsis_single_cell_gene.json") as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

        # Invalid gene
        response = self.app_client.get("/rnaseq_gene_expression/arabidopsis/single_cell/At1g0101x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Invalid database
        response = self.app_client.get("/rnaseq_gene_expression/arabidopsis/single_c;ell/At1g01010")
        expected = {"wasSuccessful": False, "error": "Invalid database"}
        self.assertEqual(response.json, expected)

        # Invalid species
        response = self.app_client.get("/rnaseq_gene_expression/abc/single_cell/At1g01010")
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(response.json, expected)

        # No data for a valid gene
        response = self.app_client.get("/rnaseq_gene_expression/arabidopsis/single_cell/At1g01011")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

    def test_get_arabidopsis_single_cell_gene_sample(self):
        """This tests the data returned for Arabidopsis single cell databases with a gene and a sample id.
        :return:
        """
        # Valid result
        response = self.app_client.get(
            "/rnaseq_gene_expression/arabidopsis/single_cell/At1g01010/cluster0_WT1.ExprMean"
        )
        expected = {"wasSuccessful": True, "data": {"cluster0_WT1.ExprMean": 0.330615}}
        self.assertEqual(response.json, expected)

        # Invalid sample id
        response = self.app_client.get("/rnaseq_gene_expression/arabidopsis/single_cell/At1g01010/abc;xyz")
        expected = {"wasSuccessful": False, "error": "Invalid sample id"}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get(
            "/rnaseq_gene_expression/arabidopsis/single_cell/At1g01011/cluster0_WT1.ExprMean"
        )
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

    def test_post_arabidopsis_single_cell_gene_sample(self):
        """This tests the data returned for Arabidopsis single cell databases with a gene and a a list of samples.
        :return:
        """
        # Valid example
        data = {
            "species": "arabidopsis",
            "database": "single_cell",
            "gene_id": "At1g01010",
            "sample_ids": [
                "cluster0_WT1.ExprMean",
                "cluster0_WT2.ExprMean",
                "cluster0_WT3.ExprMean",
            ],
        }
        response = self.app_client.post("/rnaseq_gene_expression/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "cluster0_WT1.ExprMean": 0.330615,
                "cluster0_WT2.ExprMean": 0.376952,
                "cluster0_WT3.ExprMean": 0.392354,
            },
        }
        self.assertEqual(response.json, expected)

        # Invalid data in JSON
        data = {
            "species": "arabidopsis",
            "database": "single_cell",
            "gene_id": "At1g01010",
            "sample_ids": [
                "cluster0_WT1.ExprMean",
                "cluster0_WT2.ExprMean",
                "cluster0_WT3.ExprMean",
            ],
            "abc": "xyz",
        }
        response = self.app_client.post("/rnaseq_gene_expression/", json=data)
        expected = {"wasSuccessful": False, "error": {"abc": ["Unknown field."]}}
        self.assertEqual(response.json, expected)

        # Data not found for a valid gene
        data = {
            "species": "arabidopsis",
            "database": "single_cell",
            "gene_id": "At1g01011",
            "sample_ids": [
                "cluster0_WT1.ExprMean",
                "cluster0_WT2.ExprMean",
                "cluster0_WT3.ExprMean",
            ],
        }
        response = self.app_client.post("/rnaseq_gene_expression/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        # Invalid sample ID
        data = {
            "species": "arabidopsis",
            "database": "single_cell",
            "gene_id": "At1g01011",
            "sample_ids": ["cluster0_WT1.ExprMean", "x?yx", "cluster0_WT3.ExprMean"],
        }
        response = self.app_client.post("/rnaseq_gene_expression/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid sample id"}
        self.assertEqual(response.json, expected)

    def test_get_arabidopsis_data(self):
        """
        This function run tests on all other data. Only regex test is need here
        :return:
        """
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/arabidopsis/embryo/At1g01010/pg_1")
        expected = {"wasSuccessful": True, "data": {"pg_1": 0.67}}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/rnaseq_gene_expression/arabidopsis/shoot_apex/At1g01010/ufo")
        expected = {"wasSuccessful": True, "data": {"UFO": 1.61714}}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/rnaseq_gene_expression/arabidopsis/germination/At1g01010/0h_1")
        expected = {"wasSuccessful": True, "data": {"0h_1": 2.79788}}
        self.assertEqual(response.json, expected)

        response = self.app_client.get(
            "/rnaseq_gene_expression/arabidopsis/silique/At1g01010/12_dap-1_ATCACG_L006_R1_001"
        )
        expected = {"wasSuccessful": True, "data": {"12_dap-1_ATCACG_L006_R1_001": 2.62347}}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/rnaseq_gene_expression/arabidopsis/klepikova/At1g01010/SRR3581336")
        expected = {"wasSuccessful": True, "data": {"SRR3581336": 1.80585}}
        self.assertEqual(response.json, expected)

        response = self.app_client.get(
            "/rnaseq_gene_expression/arabidopsis/dna_damage/At1g01010/col-0_rep1_12hr_minus_Y"
        )
        expected = {"wasSuccessful": True, "data": {"col-0_rep1_12hr_minus_Y": 59}}
        self.assertEqual(response.json, expected)

    def test_get_rna_expression_data(self):
        # Most branches are already tested at this point.
        # We just need to test a valid example and an invalid gene

        # Arachis
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/arachis/arachis/Adur10000_comp0_c0_seq1/Seedling_Leaf")
        expected = {"wasSuccessful": True, "data": {"Seedling_Leaf": 6.46}}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/rnaseq_gene_expression/arachis/arachis/abc/Seedling_Leaf")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Cannabis
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/cannabis/cannabis/AGQN03009284/PK-RT")
        expected = {"wasSuccessful": True, "data": {"PK-RT": 0}}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/rnaseq_gene_expression/cannabis/cannabis/abc/PK-RT")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Kalanchoe
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/kalanchoe/kalanchoe/Kaladp0001s0001/WL_Dawn_rep1")
        expected = {"wasSuccessful": True, "data": {"WL_Dawn_rep1": 6.2003}}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/rnaseq_gene_expression/kalanchoe/kalanchoe/abc/WL_Dawn_rep1")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Selaginella
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/selaginella/selaginella/Smo402070/Aerial-parts_37C_1h1")
        expected = {"wasSuccessful": True, "data": {"Aerial-parts_37C_1h1": 6.03305}}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/rnaseq_gene_expression/selaginella/selaginella/abc/Aerial-parts_37C_1h1")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Strawberry
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/strawberry/strawberry/FvH4_1g00010/Cortex_1_A")
        expected = {"wasSuccessful": True, "data": {"Cortex_1_A": 23.6302}}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/rnaseq_gene_expression/strawberry/strawberry/abc/Cortex_1_A")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Striga
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/striga/striga/StHeBC3_1.1/Seed_Germination")
        expected = {"wasSuccessful": True, "data": {"Seed_Germination": 240.31}}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/rnaseq_gene_expression/striga/striga/abc/Seed_Germination")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Triphysaria
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/triphysaria/triphysaria/TrVeBC3_1.1/Seed_Germination")
        expected = {"wasSuccessful": True, "data": {"Seed_Germination": 20.96}}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/rnaseq_gene_expression/triphysaria/triphysaria/abc/Seed_Germination")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Phelipanche
        # Valid data
        response = self.app_client.get("/rnaseq_gene_expression/phelipanche/phelipanche/OrAeBC5_1.1/Seed_Germination")
        expected = {"wasSuccessful": True, "data": {"Seed_Germination": 7.91}}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/rnaseq_gene_expression/phelipanche/phelipanche/abc/Seed_Germination")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Physcomitrella
        # Valid data
        response = self.app_client.get(
            "/rnaseq_gene_expression/physcomitrella/physcomitrella_db/Pp1s10008_1V6.1/Spores"
        )
        expected = {"wasSuccessful": True, "data": {"Spores": 23.2}}
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get("/rnaseq_gene_expression/physcomitrella/physcomitrella_db/abc/Spores")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)
