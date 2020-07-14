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
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01010')
        # Note: pytest is running from project root. So path is relative to project root
        with open('tests/data/get_arabidopsis_single_cell_gene.json') as json_file:
            expected = load(json_file)
        self.assertEqual(response.json, expected)

        # Invalid gene
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g0101x')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid gene id"
        }
        self.assertEqual(response.json, expected)

        # Invalid database
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_c;ell/At1g01010')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid database"
        }
        self.assertEqual(response.json, expected)

        # Invalid species
        response = self.app_client.get('/rnaseq_gene_expression/abc/single_cell/At1g01010')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid species"
        }
        self.assertEqual(response.json, expected)

        # No data for a valid gene
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01011')
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene"
        }
        self.assertEqual(response.json, expected)

    def test_get_arabidopsis_single_cell_gene_sample(self):
        """This tests the data returned for Arabidopsis single cell databases with a gene and a sample id.
        :return:
        """
        # Valid result
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01010/cluster0_WT1.ExprMean')
        expected = {"wasSuccessful": True, "data": {"cluster0_WT1.ExprMean": 0.330615}}
        self.assertEqual(response.json, expected)

        # Invalid sample id
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01010/abc;xyz')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid sample id"
        }
        self.assertEqual(response.json, expected)

        # Invalid gene id
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01011/cluster0_WT1.ExprMean')
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene"
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
                "cluster0_WT3.ExprMean"
            ]
        }
        response = self.app_client.post('/rnaseq_gene_expression/', json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "cluster0_WT1.ExprMean": 0.330615,
                "cluster0_WT2.ExprMean": 0.376952,
                "cluster0_WT3.ExprMean": 0.392354
            }
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
                "cluster0_WT3.ExprMean"
            ],
            "abc": "xyz"
        }
        response = self.app_client.post('/rnaseq_gene_expression/', json=data)
        expected = {'wasSuccessful': False, 'error': {'abc': ['Unknown field.']}}
        self.assertEqual(response.json, expected)

        # Data not found for a valid gene
        data = {
            "species": "arabidopsis",
            "database": "single_cell",
            "gene_id": "At1g01011",
            "sample_ids": [
                "cluster0_WT1.ExprMean",
                "cluster0_WT2.ExprMean",
                "cluster0_WT3.ExprMean"
            ]
        }
        response = self.app_client.post('/rnaseq_gene_expression/', json=data)
        expected = {'wasSuccessful': False, 'error': 'There are no data found for the given gene'}
        self.assertEqual(response.json, expected)

        # Invalid sample ID
        data = {
            "species": "arabidopsis",
            "database": "single_cell",
            "gene_id": "At1g01011",
            "sample_ids": [
                "cluster0_WT1.ExprMean",
                "x?yx",
                "cluster0_WT3.ExprMean"
            ]
        }
        response = self.app_client.post('/rnaseq_gene_expression/', json=data)
        expected = {'wasSuccessful': False, 'error': 'Invalid sample id'}
        self.assertEqual(response.json, expected)
