from api import app
from unittest import TestCase


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_arabidopsis_single_cell_gene(self):
        """
        This tests the data returned by the gene end point
        :return:
        """
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01010')
        expected = {
            "wasSuccessful": True,
            "data": {
                "cluster0_WT1.ExprMean": 0.330615,
                "cluster0_WT2.ExprMean": 0.376952,
                "cluster0_WT3.ExprMean": 0.392354,
                "cluster10_WT1.ExprMean": 0.0399103,
                "cluster10_WT2.ExprMean": 0.0128781,
                "cluster10_WT3.ExprMean": 0.00493557,
                "cluster11_WT1.ExprMean": 0.180303,
                "cluster11_WT2.ExprMean": 0.292895,
                "cluster11_WT3.ExprMean": 0.113247,
                "cluster12_WT1.ExprMean": 0.225366,
                "cluster12_WT2.ExprMean": 0.31592,
                "cluster12_WT3.ExprMean": 0.255742,
                "cluster13_WT1.ExprMean": 0.147108,
                "cluster13_WT2.ExprMean": 0.241902,
                "cluster13_WT3.ExprMean": 0.251595,
                "cluster14_WT1.ExprMean": 0.683089,
                "cluster14_WT2.ExprMean": 0.75138,
                "cluster14_WT3.ExprMean": 0.616441,
                "cluster15_WT1.ExprMean": 0.0577139,
                "cluster15_WT2.ExprMean": 0.115468,
                "cluster15_WT3.ExprMean": 0.0141389,
                "cluster16_WT1.ExprMean": 0.177473,
                "cluster16_WT2.ExprMean": 0.222742,
                "cluster16_WT3.ExprMean": 0.0914264,
                "cluster17_WT1.ExprMean": 0.0408065,
                "cluster17_WT2.ExprMean": 0.0645613,
                "cluster17_WT3.ExprMean": 0.0309355,
                "cluster18_WT1.ExprMean": 0.697676,
                "cluster18_WT2.ExprMean": 0.794452,
                "cluster18_WT3.ExprMean": 0.951476,
                "cluster19_WT1.ExprMean": 0.314653,
                "cluster19_WT2.ExprMean": 0.456848,
                "cluster19_WT3.ExprMean": 0.337701,
                "cluster1_WT1.ExprMean": 0.104124,
                "cluster1_WT2.ExprMean": 0.183412,
                "cluster1_WT3.ExprMean": 0.165289,
                "cluster20_WT1.ExprMean": 0.311621,
                "cluster20_WT2.ExprMean": 0.505607,
                "cluster20_WT3.ExprMean": 0.466686,
                "cluster21_WT1.ExprMean": 0.279148,
                "cluster21_WT2.ExprMean": 0.307624,
                "cluster21_WT3.ExprMean": 0.273229,
                "cluster22_WT1.ExprMean": 0.154758,
                "cluster22_WT2.ExprMean": 0.246915,
                "cluster22_WT3.ExprMean": 0.215633,
                "cluster23_WT1.ExprMean": 0.278561,
                "cluster23_WT2.ExprMean": 0.313757,
                "cluster23_WT3.ExprMean": 0.341591,
                "cluster24_WT1.ExprMean": 0.399525,
                "cluster24_WT2.ExprMean": 0.326986,
                "cluster24_WT3.ExprMean": 0.328818,
                "cluster25_WT1.ExprMean": 0.0799877,
                "cluster25_WT2.ExprMean": 0.0296777,
                "cluster25_WT3.ExprMean": 0.0202025,
                "cluster26_WT1.ExprMean": 0.0290226,
                "cluster26_WT2.ExprMean": 0,
                "cluster26_WT3.ExprMean": 0,
                "cluster27_WT1.ExprMean": 0.0924709,
                "cluster27_WT2.ExprMean": 0.0508237,
                "cluster27_WT3.ExprMean": 0.00982657,
                "cluster28_WT1.ExprMean": 0.0557328,
                "cluster28_WT2.ExprMean": 0.101592,
                "cluster28_WT3.ExprMean": 0.107528,
                "cluster29_WT1.ExprMean": 0.291406,
                "cluster29_WT2.ExprMean": 0.231561,
                "cluster29_WT3.ExprMean": 0.201914,
                "cluster2_WT1.ExprMean": 0.0327218,
                "cluster2_WT2.ExprMean": 0.0337024,
                "cluster2_WT3.ExprMean": 0.0206359,
                "cluster30_WT1.ExprMean": 0.0319319,
                "cluster30_WT2.ExprMean": 0.111761,
                "cluster30_WT3.ExprMean": 0.157263,
                "cluster31_WT1.ExprMean": 0.52613,
                "cluster31_WT2.ExprMean": 0.566468,
                "cluster31_WT3.ExprMean": 0.436468,
                "cluster32_WT1.ExprMean": 0.342944,
                "cluster32_WT2.ExprMean": 0.371802,
                "cluster32_WT3.ExprMean": 0.275506,
                "cluster33_WT1.ExprMean": 0.147324,
                "cluster33_WT2.ExprMean": 0,
                "cluster33_WT3.ExprMean": 0.0330883,
                "cluster34_WT1.ExprMean": 0.0535194,
                "cluster34_WT2.ExprMean": 0,
                "cluster34_WT3.ExprMean": 0,
                "cluster35_WT1.ExprMean": 0.224244,
                "cluster35_WT2.ExprMean": 0,
                "cluster35_WT3.ExprMean": 0.118697,
                "cluster3_WT1.ExprMean": 0.214786,
                "cluster3_WT2.ExprMean": 0.241307,
                "cluster3_WT3.ExprMean": 0.134913,
                "cluster4_WT1.ExprMean": 0.117571,
                "cluster4_WT2.ExprMean": 0.0735138,
                "cluster4_WT3.ExprMean": 0.116268,
                "cluster5_WT1.ExprMean": 0.0439212,
                "cluster5_WT2.ExprMean": 0.0570379,
                "cluster5_WT3.ExprMean": 0.0779526,
                "cluster6_WT1.ExprMean": 0.379817,
                "cluster6_WT2.ExprMean": 0.640221,
                "cluster6_WT3.ExprMean": 0.357844,
                "cluster7_WT1.ExprMean": 0.555463,
                "cluster7_WT2.ExprMean": 0.671035,
                "cluster7_WT3.ExprMean": 0.505183,
                "cluster8_WT1.ExprMean": 0.0302899,
                "cluster8_WT2.ExprMean": 0,
                "cluster8_WT3.ExprMean": 0.0236176,
                "cluster9_WT1.ExprMean": 0.675148,
                "cluster9_WT2.ExprMean": 0.750971,
                "cluster9_WT3.ExprMean": 0.613557,
                "Med_CTRL": 0.192663
            }
        }
        self.assertEqual(response.json, expected)

    def test_get_arabidopsis_single_cell_gene_sample(self):
        """
        This tests the data returned for Arabidopsis single cell databases with a gene and a sample id.
        :return:
        """
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01010/cluster0_WT1.ExprMean')
        expected = {"wasSuccessful": True, "data": {"cluster0_WT1.ExprMean": 0.330615}}
        self.assertEqual(response.json, expected)

    def test_get_arabidopsis_gene_invalid(self):
        """
        This function tests if the gene is valid.
        :return:
        """
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g0101x')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid gene id"
        }
        self.assertEqual(response.json, expected)

    def test_get_database_invalid(self):
        """
        This function tests if the database is valid.
        :return:
        """
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_c;ell/At1g01010')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid database"
        }
        self.assertEqual(response.json, expected)

    def test_get_species_invalid(self):
        """
        This function tests if the species is valid.
        :return:
        """
        response = self.app_client.get('/rnaseq_gene_expression/abc/single_cell/At1g01010')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid species"
        }
        self.assertEqual(response.json, expected)

    def test_get_gene_no_data(self):
        """
        This function tests if the gene has data
        :return:
        """
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01011')
        expected = {
            "wasSuccessful": False,
            "error": "There is no data found for the given gene"
        }
        self.assertEqual(response.json, expected)

    def test_get_gene_no_data_with_sample(self):
        """
        This function tests if the gene had data given a sample
        :return:
        """
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01011/cluster0_WT1.ExprMean')
        expected = {
            "wasSuccessful": False,
            "error": "There is no data found for the given gene"
        }
        self.assertEqual(response.json, expected)

    def test_get_sample_invalid(self):
        """
        This function tests if the sample is valid.
        :return:
        """
        response = self.app_client.get('/rnaseq_gene_expression/arabidopsis/single_cell/At1g01010/abc;xyz')
        expected = {
            "wasSuccessful": False,
            "error": "Invalid sample id"
        }
        self.assertEqual(response.json, expected)

    def test_post_arabidopsis_single_cell_gene_sample(self):
        """
        This tests the data returned for Arabidopsis single cell databases with a gene and a a list of samples.
        :return:
        """
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

    def test_post_arabidopsis_single_cell_gene_sample_invalid_jsaon(self):
        """
        This tests the data returned for Arabidopsis single cell databases with a gene and a list of samples.
        :return:
        """
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

    def test_post_arabidopsis_single_cell_gene_sample_no_data(self):
        """
        This tests the data returned for Arabidopsis single cell databases with a gene and a list of samples.
        :return:
        """
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

    def test_post_arabidopsis_single_cell_gene_sample_invalid_sample(self):
        """
        This tests the data returned for Arabidopsis single cell databases with a gene and a sample id.
        :return:
        """
        data = {
            "species": "arabidopsis",
            "database": "single_cell",
            "gene_id": "At1g01011",
            "sample_ids": [
                "x?yx"
            ]
        }
        response = self.app_client.post('/rnaseq_gene_expression/', json=data)
        expected = {'wasSuccessful': False, 'error': 'Invalid sample id'}
        self.assertEqual(response.json, expected)
