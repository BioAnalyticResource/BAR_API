from api import app, db
from unittest import TestCase
import json
import pandas


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()
        with app.app_context():
            df = pandas.read_csv('tests/data/summarization_gene_expression_test_table.csv')
            df = df.melt(id_vars=["Gene"], var_name="Sample", value_name="Value")
            con = db.get_engine(bind='summarization')
            df.to_sql("test", con, if_exists='replace', index=True)

    def tearDown(self):
        with app.app_context():
            con = db.get_engine(bind='summarization')
            command = "DROP TABLE IF EXISTS test"
            con.execute(command)

    def test_get_gene_value(self):
        response = self.app_client.get('/summarization_gene_expression/value?id=test&gene=AT1G01010', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "sample1": 32,
            "sample2": 54
        }
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_get_samples(self):
        response = self.app_client.get('/summarization_gene_expression/samples?id=test', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        expected = [
            "sample1",
            "sample2"
        ]
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_get_genes(self):
        response = self.app_client.get('/summarization_gene_expression/genes?id=test', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        expected = [
            "AT1G01010",
            "AT1G01020",
            "AT1G01030"
        ]
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_find_gene(self):
        response = self.app_client.get('/summarization_gene_expression/find_gene?id=test&string=AT1G0101', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        expected = [
            "AT1G01010"
        ]
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)

    def test_table_exists(self):
        response = self.app_client.get('/summarization_gene_expression/table_exists?id=test', headers={"x-api-key": "bb5a52387069485486b2f4861c2826dd"})
        data = json.loads(response.get_data(as_text=True))
        expected = True
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data, expected)
