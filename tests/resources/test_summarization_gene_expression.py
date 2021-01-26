from api import app
from unittest import TestCase
import json


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_gene_value(self):
        response = self.app_client.get('/summarization_gene_expression/value/test/At1g01010', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "sample1": 32,
            "sample2": 54
        }
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_get_samples(self):
        response = self.app_client.get('/summarization_gene_expression/samples/test', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        print(data)
        expected = [
            "sample1",
            "sample2"
        ]
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_get_genes(self):
        response = self.app_client.get('/summarization_gene_expression/genes/test', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        expected = [
            "AT1G01010",
            "AT1G01020",
            "AT1G01030"
        ]
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_find_gene(self):
        response = self.app_client.get('/summarization_gene_expression/find_gene/test/AT1G0101', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        expected = [
            "AT1G01010"
        ]
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_table_exists(self):
        response = self.app_client.get('/summarization_gene_expression/table_exists/test', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        expected = True
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)
