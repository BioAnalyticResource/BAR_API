from api import app
from unittest import TestCase
import json


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_post_gene_aliases(self):
        """This test POST request to /gene_information/gene_aliases/
        :return:
        """
        data = {"species": "arabidopsis", "genes": ["AT1G01010", "AT1G01020"]}
        expected = {
            "wasSuccessful": True,
            "data": [
                {"gene": "At1g01010", "aliases": ["ANAC001", "At1g01010", "At1g01010"]},
                {"gene": "At1g01020", "aliases": ["ARV1"]},
            ],
        }
        response = self.app_client.post("/gene_information/gene_aliases", json=data)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json, expected)

        # Invalid gene
        data = {"species": "abc", "genes": ["AT1G01010", "AT1G01020"]}
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        response = self.app_client.post("/gene_information/gene_aliases", json=data)
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json, expected)

        # Invalid gene
        data = {"species": "arabidopsis", "genes": ["abc", "AT1G01020"]}
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        response = self.app_client.post("/gene_information/gene_aliases", json=data)
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json, expected)

        # No data
        data = {"species": "arabidopsis", "genes": ["AT1G01011", "AT1G01021"]}
        expected = {"wasSuccessful": False, "error": "No data for the given species/genes"}
        response = self.app_client.post("/gene_information/gene_aliases", json=data)
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json, expected)

    def test_get_arabidopsis_gene_publications(self):
        """This tests checks GET request for gene publications Arabidopsis
        :return:
        """
        # Valid data
        response = self.app_client.get("/gene_information/gene_publications/arabidopsis/AT1G01020")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "gene_id": "AT1G01020",
                    "author": "Forés O",
                    "year": "2006",
                    "journal": "Biochim. Biophys. Acta",
                    "title": "Arabidopsis thaliana expresses two functional isoforms of Arvp, a protein involved in the regulation of cellular lipid homeostasis.",
                    "pubmed": "16725371",
                },
                {
                    "gene_id": "AT1G01020",
                    "author": "Theologis A",
                    "year": "2000",
                    "journal": "Nature",
                    "title": "Sequence and analysis of chromosome 1 of the plant Arabidopsis thaliana.",
                    "pubmed": "11130712",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_publications/arabidopsis/AT1G01020.")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "gene_id": "AT1G01020",
                    "author": "Forés O",
                    "year": "2006",
                    "journal": "Biochim. Biophys. Acta",
                    "title": "Arabidopsis thaliana expresses two functional isoforms of Arvp, a protein involved in the regulation of cellular lipid homeostasis.",
                    "pubmed": "16725371",
                },
                {
                    "gene_id": "AT1G01020",
                    "author": "Theologis A",
                    "year": "2000",
                    "journal": "Nature",
                    "title": "Sequence and analysis of chromosome 1 of the plant Arabidopsis thaliana.",
                    "pubmed": "11130712",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_publications/arabidopsis/AT1G01020.0")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "gene_id": "AT1G01020",
                    "author": "Forés O",
                    "year": "2006",
                    "journal": "Biochim. Biophys. Acta",
                    "title": "Arabidopsis thaliana expresses two functional isoforms of Arvp, a protein involved in the regulation of cellular lipid homeostasis.",
                    "pubmed": "16725371",
                },
                {
                    "gene_id": "AT1G01020",
                    "author": "Theologis A",
                    "year": "2000",
                    "journal": "Nature",
                    "title": "Sequence and analysis of chromosome 1 of the plant Arabidopsis thaliana.",
                    "pubmed": "11130712",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_publications/arabidopsis/AT1G01020.1")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "gene_id": "AT1G01020",
                    "author": "Forés O",
                    "year": "2006",
                    "journal": "Biochim. Biophys. Acta",
                    "title": "Arabidopsis thaliana expresses two functional isoforms of Arvp, a protein involved in the regulation of cellular lipid homeostasis.",
                    "pubmed": "16725371",
                },
                {
                    "gene_id": "AT1G01020",
                    "author": "Theologis A",
                    "year": "2000",
                    "journal": "Nature",
                    "title": "Sequence and analysis of chromosome 1 of the plant Arabidopsis thaliana.",
                    "pubmed": "11130712",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_publications/arabidopsis/AT1G01020.12345")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "gene_id": "AT1G01020",
                    "author": "Forés O",
                    "year": "2006",
                    "journal": "Biochim. Biophys. Acta",
                    "title": "Arabidopsis thaliana expresses two functional isoforms of Arvp, a protein involved in the regulation of cellular lipid homeostasis.",
                    "pubmed": "16725371",
                },
                {
                    "gene_id": "AT1G01020",
                    "author": "Theologis A",
                    "year": "2000",
                    "journal": "Nature",
                    "title": "Sequence and analysis of chromosome 1 of the plant Arabidopsis thaliana.",
                    "pubmed": "11130712",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        # Data not found, but gene is valid
        response = self.app_client.get("/gene_information/gene_publications/arabidopsis/AT1G01035")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_publications/arabidopsis/AT1G010400")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        # Invalid Gene
        response = self.app_client.get("/gene_information/gene_publications/arabidopsis/001G01030")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Invalid Species
        response = self.app_client.get("/gene_information/gene_publications/x/AT1G01020")
        expected = {"wasSuccessful": False, "error": "No data for the given species"}
        self.assertEqual(response.json, expected)

    def test_get_arabidopsis_gene_by_location(self):
        """This tests checks GET request for genes of Arabidopsis at a given location
        :return:
        """
        # Valid data
        response = self.app_client.get("/gene_information/genes_by_position/arabidopsis/1/3000/9000")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "id": "AT1G01010",
                    "start": 3631,
                    "end": 5899,
                    "strand": "+",
                    "aliases": ["ANAC001", "NAC001", "NTL10"],
                    "annotation": "NAC domain containing protein 1",
                },
                {
                    "id": "AT1G01020",
                    "start": 5928,
                    "end": 8737,
                    "strand": "-",
                    "aliases": ["ARV1"],
                    "annotation": "Arv1-like protein",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/genes_by_position/arabidopsis/1/5800/6000")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "id": "AT1G01010",
                    "start": 3631,
                    "end": 5899,
                    "strand": "+",
                    "aliases": ["ANAC001", "NAC001", "NTL10"],
                    "annotation": "NAC domain containing protein 1",
                },
                {
                    "id": "AT1G01020",
                    "start": 5928,
                    "end": 8737,
                    "strand": "-",
                    "aliases": ["ARV1"],
                    "annotation": "Arv1-like protein",
                },
            ],
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/genes_by_position/arabidopsis/1/12000/14000")
        expected = {
            "wasSuccessful": True,
            "data": [
                {
                    "id": "AT1G01030",
                    "start": 11649,
                    "end": 13714,
                    "strand": "-",
                    "aliases": ["NGA3"],
                    "annotation": "AP2/B3-like transcriptional factor family protein",
                }
            ],
        }
        self.assertEqual(response.json, expected)

        # Data not found, but gene is valid
        response = self.app_client.get("/gene_information/genes_by_position/arabidopsis/1/0/200")
        expected = {"wasSuccessful": True, "data": []}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/genes_by_position/arabidopsis/1/1000000/2000000")
        expected = {"wasSuccessful": True, "data": []}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/genes_by_position/arabidopsis/5/3000/6000")
        expected = {"wasSuccessful": True, "data": []}
        self.assertEqual(response.json, expected)

        # Invalid start/end parameter
        response = self.app_client.get("/gene_information/genes_by_position/arabidopsis/1/3000/2000")
        expected = {"wasSuccessful": False, "error": "Start location should be smaller than the end location"}
        self.assertEqual(response.json, expected)

        # Invalid chromosome
        response = self.app_client.get("/gene_information/genes_by_position/arabidopsis/Chr10/3000/6000")
        expected = {"wasSuccessful": False, "error": "Invalid chromosome"}
        self.assertEqual(response.json, expected)

        # Invalid species
        response = self.app_client.get("/gene_information/genes_by_position/poplar/1/3000/6000")
        expected = {"wasSuccessful": False, "error": "No data for the given species"}
        self.assertEqual(response.json, expected)

    def test_query_genes(self):
        """This tests checks POST request for genes of Arabidopsis given its terms
        :return:
        """
        # Valid data
        response = self.app_client.post(
            "/gene_information/gene_query", json={"species": "arabidopsis", "terms": ["AT1G01030"]}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01030": {
                    "id": "AT1G01030",
                    "chromosome": "Chr1",
                    "start": 11649,
                    "end": 13714,
                    "strand": "-",
                    "aliases": ["NGA3"],
                    "annotation": "AP2/B3-like transcriptional factor family protein",
                }
            },
        }
        self.assertEqual(data, expected)

        response = self.app_client.post(
            "/gene_information/gene_query",
            json={"species": "arabidopsis", "terms": ["AT1G01010", "AT1G01020"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01010": {
                    "id": "AT1G01010",
                    "chromosome": "Chr1",
                    "start": 3631,
                    "end": 5899,
                    "strand": "+",
                    "aliases": ["ANAC001", "NAC001", "NTL10"],
                    "annotation": "NAC domain containing protein 1",
                },
                "AT1G01020": {
                    "id": "AT1G01020",
                    "chromosome": "Chr1",
                    "start": 5928,
                    "end": 8737,
                    "strand": "-",
                    "aliases": ["ARV1"],
                    "annotation": "Arv1-like protein",
                },
            },
        }
        self.assertEqual(data, expected)

        response = self.app_client.post(
            "/gene_information/gene_query",
            json={"species": "arabidopsis", "terms": ["AT1G01020", "AT1G01020"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01020": {
                    "id": "AT1G01020",
                    "chromosome": "Chr1",
                    "start": 5928,
                    "end": 8737,
                    "strand": "-",
                    "aliases": ["ARV1"],
                    "annotation": "Arv1-like protein",
                }
            },
        }
        self.assertEqual(data, expected)

        # Terms contain those cannot find data
        response = self.app_client.post(
            "/gene_information/gene_query", json={"species": "arabidopsis", "terms": ["AT1G01040.3"]}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": True, "data": {}}
        self.assertEqual(data, expected)

        response = self.app_client.post(
            "/gene_information/gene_query",
            json={"species": "arabidopsis", "terms": ["AT1G01010.3", "AT1G01010"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01010": {
                    "id": "AT1G01010",
                    "chromosome": "Chr1",
                    "start": 3631,
                    "end": 5899,
                    "strand": "+",
                    "aliases": ["ANAC001", "NAC001", "NTL10"],
                    "annotation": "NAC domain containing protein 1",
                }
            },
        }
        self.assertEqual(data, expected)

        response = self.app_client.post(
            "/gene_information/gene_query",
            json={"species": "arabidopsis", "terms": ["AT1G01030", "AT1G01035"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01030": {
                    "id": "AT1G01030",
                    "chromosome": "Chr1",
                    "start": 11649,
                    "end": 13714,
                    "strand": "-",
                    "aliases": ["NGA3"],
                    "annotation": "AP2/B3-like transcriptional factor family protein",
                }
            },
        }
        self.assertEqual(data, expected)

        # Invalid gene
        response = self.app_client.post(
            "/gene_information/gene_query", json={"species": "arabidopsis", "terms": ["001G01030"]}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Input list contains invalid term"}
        self.assertEqual(data, expected)

        response = self.app_client.post(
            "/gene_information/gene_query",
            json={"species": "arabidopsis", "terms": ["001G01010", "At1g01010"]},
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "Input list contains invalid term"}
        self.assertEqual(data, expected)

        # Invalid species
        response = self.app_client.post(
            "/gene_information/gene_query", json={"species": "xxx", "terms": ["At1g01010", "At1g01020"]}
        )
        data = json.loads(response.get_data(as_text=True))
        expected = {"wasSuccessful": False, "error": "No data for the given species"}
        self.assertEqual(data, expected)

    def test_query_single_gene(self):
        """This tests checks GET request for genes of Arabidopsis given a single term
        :return:
        """
        # Valid data
        response = self.app_client.get("/gene_information/single_gene_query/arabidopsis/At1g01030")
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01030": {
                    "id": "AT1G01030",
                    "chromosome": "Chr1",
                    "start": 11649,
                    "end": 13714,
                    "strand": "-",
                    "aliases": ["NGA3"],
                    "annotation": "AP2/B3-like transcriptional factor family protein",
                }
            },
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/single_gene_query/arabidopsis/AT1G01010")
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01010": {
                    "id": "AT1G01010",
                    "chromosome": "Chr1",
                    "start": 3631,
                    "end": 5899,
                    "strand": "+",
                    "aliases": ["ANAC001", "NAC001", "NTL10"],
                    "annotation": "NAC domain containing protein 1",
                }
            },
        }
        self.assertEqual(response.json, expected)

        # Term cannot find data
        response = self.app_client.get("/gene_information/single_gene_query/arabidopsis/At1g01040.3")
        expected = {"wasSuccessful": True, "data": {}}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/single_gene_query/arabidopsis/At1g01035")
        expected = {"wasSuccessful": True, "data": {}}
        self.assertEqual(response.json, expected)

        # Invalid gene
        response = self.app_client.get("/gene_information/single_gene_query/arabidopsis/001G01030")
        expected = {"wasSuccessful": False, "error": "Input term invalid"}
        self.assertEqual(response.json, expected)

        # Invalid species
        response = self.app_client.get("/gene_information/single_gene_query/xxx/At1g01020")
        expected = {"wasSuccessful": False, "error": "No data for the given species"}
        self.assertEqual(response.json, expected)

    def test_get_arabidopsis_gene_isoform(self):
        """This tests checks GET request for gene isoforms Arabidopsis
        :return:
        """
        # Valid data
        response = self.app_client.get("/gene_information/gene_isoforms/arabidopsis/AT1G01020")
        expected = {"wasSuccessful": True, "data": ["AT1G01020.1", "AT1G01020.2"]}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/poplar/Potri.001G000300")
        expected = {"wasSuccessful": True, "data": ["Potri.001G000300.1"]}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/tomato/Solyc00g005000")
        expected = {"wasSuccessful": True, "data": ["Solyc00g005000.3.1"]}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/soybean/Glyma.01G000100")
        expected = {"wasSuccessful": True, "data": ["Glyma.01G000100"]}
        self.assertEqual(response.json, expected)

        # Data not found, but gene is valid
        response = self.app_client.get("/gene_information/gene_isoforms/arabidopsis/At3g24651")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        # Data not found, but gene is valid
        response = self.app_client.get("/gene_information/gene_isoforms/poplar/Potri.001G000201")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/tomato/Solyc00g005001")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/soybean/Glyma.01G000102")
        expected = {
            "wasSuccessful": False,
            "error": "There are no data found for the given gene",
        }
        self.assertEqual(response.json, expected)

        # Invalid Gene
        response = self.app_client.get("/gene_information/gene_isoforms/arabidopsis/At3g2465x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/poplar/Potri.001G00020x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/tomato/Solyc00g00500x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        response = self.app_client.get("/gene_information/gene_isoforms/soybean/Glyma.01G00010x")
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Invalid Species
        response = self.app_client.get("/gene_information/gene_isoforms/x/At3g24650")
        expected = {"wasSuccessful": False, "error": "No data for the given species"}
        self.assertEqual(response.json, expected)

    def test_post_arabidopsis_gene_isoform(self):
        """This tests the data returned for Arabidopsis gene isoforms.
        :return:
        """
        # Valid example
        data = {"species": "arabidopsis", "genes": ["AT1G01010", "AT1G01020"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "AT1G01010": ["AT1G01010.1"],
                "AT1G01020": ["AT1G01020.1", "AT1G01020.2"],
            },
        }
        self.assertEqual(response.json, expected)

        data = {"species": "poplar", "genes": ["Potri.001G000300", "Potri.001G000400"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "Potri.001G000300": ["Potri.001G000300.1"],
                "Potri.001G000400": [
                    "Potri.001G000400.1",
                    "Potri.001G000400.2",
                    "Potri.001G000400.3",
                    "Potri.001G000400.4",
                ],
            },
        }
        self.assertEqual(response.json, expected)

        data = {"species": "soybean", "genes": ["Glyma.01G000100", "Glyma.01G000200"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {
                "Glyma.01G000100": ["Glyma.01G000100"],
                "Glyma.01G000200": ["Glyma.01G000200"],
            },
        }
        self.assertEqual(response.json, expected)

        data = {"species": "tomato", "genes": ["Solyc00g005000"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"Solyc00g005000": ["Solyc00g005000.3.1"]},
        }
        self.assertEqual(response.json, expected)

        # Invalid data in JSON
        data = {
            "species": "arabidopsis",
            "genes": ["AT1G01010", "AT1G01020"],
            "abc": "xyz",
        }
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": {"abc": ["Unknown field."]}}
        self.assertEqual(response.json, expected)

        data = {
            "species": "poplar",
            "genes": ["Potri.001G000200", "Potri.001G000300"],
            "abc": "xyz",
        }
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": {"abc": ["Unknown field."]}}
        self.assertEqual(response.json, expected)

        data = {
            "species": "soybean",
            "genes": ["Glyma.01G000100", "Glyma.01G000200"],
            "abc": "xyz",
        }
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": {"abc": ["Unknown field."]}}
        self.assertEqual(response.json, expected)

        # Data not found for a valid gene
        data = {"species": "arabidopsis", "genes": ["AT1G01011", "AT1G01020"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"AT1G01020": ["AT1G01020.1", "AT1G01020.2"]},
        }
        self.assertEqual(response.json, expected)

        data = {"species": "poplar", "genes": ["Potri.001G000201", "Potri.001G000300"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"Potri.001G000300": ["Potri.001G000300.1"]},
        }
        self.assertEqual(response.json, expected)

        data = {"species": "soybean", "genes": ["Glyma.01G000100", "Glyma.01G000101"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"Glyma.01G000100": ["Glyma.01G000100"]},
        }
        self.assertEqual(response.json, expected)

        # Check if arabidopsis gene is valid
        data = {"species": "arabidopsis", "genes": ["AT1G01011", "AT1G01020"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": True,
            "data": {"AT1G01020": ["AT1G01020.1", "AT1G01020.2"]},
        }
        self.assertEqual(response.json, expected)

        # Check if gene is valid
        data = {"species": "arabidopsis", "genes": ["abc"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        data = {"species": "poplar", "genes": ["abc"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        data = {"species": "tomato", "genes": ["abc"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        data = {"species": "soybean", "genes": ["abc"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid gene id"}
        self.assertEqual(response.json, expected)

        # Check if there is data for the given gene
        data = {"species": "arabidopsis", "genes": ["AT1G01011"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)

        # Check if species is valid
        data = {"species": "abc", "genes": ["AT1G01010", "AT1G01020"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {"wasSuccessful": False, "error": "Invalid species"}
        self.assertEqual(response.json, expected)

        # Check if there is data for the given gene
        data = {"species": "arabidopsis", "genes": ["AT1G01011"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)

        data = {"species": "poplar", "genes": ["Potri.001G000201"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)

        data = {"species": "tomato", "genes": ["Solyc00g005001"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)

        data = {"species": "soybean", "genes": ["Glyma.01G000101"]}
        response = self.app_client.post("/gene_information/gene_isoforms/", json=data)
        expected = {
            "wasSuccessful": False,
            "error": "No data for the given species/genes",
        }
        self.assertEqual(response.json, expected)
