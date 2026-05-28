"""
Reena Obmina | UTEA Project 2026 | University of Toronto

Tests for the gene density endpoint (GET /gene_density).

Covers valid requests, single-bin gene aggregation, multi-bin gene spanning,
and all error cases (missing/invalid parameters).

Usage::

    python3 -m pytest tests/resources/test_gene_density.py -v
"""

from api import app
from unittest import TestCase

EXPECTED_CHR_NAMES = ["Chr 1", "Chr 2", "Chr 3", "Chr 4", "Chr 5", "Chr C", "Chr M"]


class TestGeneDensity(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_valid_request(self):
        """Response has correct structure for a valid species/bin_size."""
        response = self.app_client.get("/gene_density?species=Arabidopsis_thaliana&bin_size=143061.51645207437")
        self.assertEqual(response.status_code, 200)
        data = response.json
        self.assertTrue(data["wasSuccessful"])
        result = data["data"]
        self.assertIsInstance(result, list)
        self.assertEqual(len(result), 7)
        names = [entry["name"] for entry in result]
        self.assertEqual(names, EXPECTED_CHR_NAMES)
        for entry in result:
            self.assertIsInstance(entry["density"], list)
            self.assertTrue(all(isinstance(v, int) and v >= 0 for v in entry["density"]))

    def test_single_bin_genes(self):
        """All three test genes (AT1G*) fit in a single bin at bin_size=10000."""
        # AT1G01010 (3631-5899) and AT1G01020 (5928-8737) → bin 0
        # AT1G01030 (11649-13714)                          → bin 1
        response = self.app_client.get("/gene_density?species=Arabidopsis_thaliana&bin_size=10000")
        self.assertEqual(response.status_code, 200)
        chr1 = response.json["data"][0]
        self.assertEqual(chr1["name"], "Chr 1")
        self.assertEqual(chr1["density"][0], 2)
        self.assertEqual(chr1["density"][1], 1)

    def test_multi_bin_genes(self):
        """AT1G01020 and AT1G01030 each span two bins at bin_size=3000."""
        # AT1G01010 (3631-5899): start_bin=1 end_bin=1 → single, bin 1
        # AT1G01020 (5928-8737): start_bin=1 end_bin=2 → multi,  bins 1 and 2
        # AT1G01030 (11649-13714): start_bin=3 end_bin=4 → multi, bins 3 and 4
        response = self.app_client.get("/gene_density?species=Arabidopsis_thaliana&bin_size=3000")
        self.assertEqual(response.status_code, 200)
        density = response.json["data"][0]["density"]
        self.assertEqual(density[1], 2)  # AT1G01010 + AT1G01020
        self.assertEqual(density[2], 1)  # AT1G01020 overflow
        self.assertEqual(density[3], 1)  # AT1G01030
        self.assertEqual(density[4], 1)  # AT1G01030 overflow

    def test_missing_species(self):
        response = self.app_client.get("/gene_density?bin_size=143061.51645207437")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.json["wasSuccessful"])

    def test_missing_bin_size(self):
        response = self.app_client.get("/gene_density?species=Arabidopsis_thaliana")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.json["wasSuccessful"])

    def test_invalid_species(self):
        response = self.app_client.get("/gene_density?species=potato&bin_size=143061.51645207437")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.json["wasSuccessful"])

    def test_invalid_bin_size(self):
        response = self.app_client.get("/gene_density?species=Arabidopsis_thaliana&bin_size=abc")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.json["wasSuccessful"])

    def test_non_positive_bin_size(self):
        response = self.app_client.get("/gene_density?species=Arabidopsis_thaliana&bin_size=0")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.json["wasSuccessful"])

        response = self.app_client.get("/gene_density?species=Arabidopsis_thaliana&bin_size=-5000")
        self.assertEqual(response.status_code, 400)
        self.assertFalse(response.json["wasSuccessful"])
