import re
from unittest import TestCase
from api.utils.bar_utils import BARUtils, load_combined_master


def gene_id_matches(gene, project):
    """1:1 lookup: full-match a gene ID against the project's regex in combined_master."""
    pattern = load_combined_master()["gene_id_patterns"].get(project)
    return bool(pattern and re.fullmatch(pattern, gene, re.I))


class UtilsUnitTest(TestCase):
    def test_error_exit(self):
        msg = "A test error message"
        result = BARUtils.error_exit(msg)
        expected = {"wasSuccessful": False, "error": msg}
        self.assertEqual(result, expected)

    def test_successful_exit(self):
        msg = "A successful test message"
        result = BARUtils.success_exit(msg)
        expected = {"wasSuccessful": True, "data": msg}
        self.assertEqual(result, expected)

    def test_is_arabidopsis_gene_valid(self):
        # Valid gene
        result = gene_id_matches("At1g01010", "arabidopsis")
        self.assertTrue(result)
        result = gene_id_matches("At1g01010.1", "arabidopsis")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "arabidopsis")
        self.assertFalse(result)
        # Two-digit isoform suffix: accepted by Vincent's efp_arabidopsis
        # registry pattern.
        result = gene_id_matches("At1g01010.11", "arabidopsis")
        self.assertTrue(result)

    def test_is_brassica_rapa_gene_valid(self):
        # Valid gene
        result = gene_id_matches("BraA01g000010", "brassica_rapa")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "brassica_rapa")
        self.assertFalse(result)

    def test_is_grape_gene_valid(self):
        result = gene_id_matches("VIT_00s0120g00060", "grape")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "grape")
        self.assertFalse(result)

    def test_is_kalanchoe_gene_valid(self):
        # Valid gene
        result = gene_id_matches("Kaladp0001s0001", "kalanchoe")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "kalanchoe")
        self.assertFalse(result)

    def test_is_phelipanche_gene_valid(self):
        # Valid gene
        result = gene_id_matches("OrAeBC5_9992.10", "phelipanche")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "phelipanche")
        self.assertFalse(result)

    def test_is_physcomitrella_gene_valid(self):
        # Valid gene
        result = gene_id_matches("Pp1s9_70V6.1", "physcomitrella")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "physcomitrella")
        self.assertFalse(result)

    def test_is_selaginella_gene_valid(self):
        # Valid gene
        result = gene_id_matches("Smo402070", "selaginella")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "selaginella")
        self.assertFalse(result)

    def test_is_strawberry_gene_valid(self):
        # Valid gene
        result = gene_id_matches("FvH4_1g00010", "strawberry")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "strawberry")
        self.assertFalse(result)

    def test_is_striga_gene_valid(self):
        # Valid gene
        result = gene_id_matches("StHeBC3_9993.10", "striga")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "striga")
        self.assertFalse(result)

    def test_is_triphysaria_gene_valid(self):
        # Valid gene
        result = gene_id_matches("TrVeBC3_9999.18", "triphysaria")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "triphysaria")
        self.assertFalse(result)

    def test_is_tomato_gene_valid(self):
        # For some reason, coverage is saying that we need this test
        result = gene_id_matches("Solyc04g014530", "tomato")
        self.assertTrue(result)

    def test_is_integer(self):
        # Valid result
        result = BARUtils.is_integer("5")
        self.assertTrue(result)

        # Valid but too large
        result = BARUtils.is_integer("99999999999999")
        self.assertFalse(result)

        # Invalid
        result = BARUtils.is_integer("abc")
        self.assertFalse(result)

    def test_is_poplar_gene_valid(self):
        # Valid gene
        result = gene_id_matches("Potri.019G123900.1", "poplar")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "poplar")
        self.assertFalse(result)

    def test_is_sorghum_gene_valid(self):
        # Valid gene
        result = gene_id_matches("Sobic.001G000100", "sorghum")
        self.assertTrue(result)

        # Invalid gene
        result = gene_id_matches("abc", "sorghum")
        self.assertFalse(result)

    def test_format_poplar(self):
        # Test format
        result = BARUtils.format_poplar("potri.019g123900.1")
        expected = "Potri.019G123900.1"
        self.assertEqual(result, expected)

    def test_gene_id_patterns_exist(self):
        """All expected project keys must be present in combined_master's gene_id_patterns."""
        required = [
            "arabidopsis", "seedcoat",
            "barley", "rice", "medicago", "poplar",
            "soybean", "maize", "triticale", "human",
        ]
        patterns = load_combined_master()["gene_id_patterns"]
        for key in required:
            self.assertIn(key, patterns, "Missing gene_id_patterns key: {}".format(key))

    def test_gene_id_pattern_arabidopsis(self):
        """efp_arabidopsis accepts AGI, ATH1 probeset IDs, and standalone numerics."""
        # Valid canonical AGI gene IDs
        self.assertTrue(gene_id_matches("AT2G21130", "arabidopsis"))
        self.assertTrue(gene_id_matches("At1g01010", "arabidopsis"))
        self.assertTrue(gene_id_matches("AtCg00020", "arabidopsis"))

        # Valid Arabidopsis ATH1 probeset IDs (from sample data)
        self.assertTrue(gene_id_matches("267643_at", "arabidopsis"))
        self.assertTrue(gene_id_matches("267644_s_at", "arabidopsis"))
        self.assertTrue(gene_id_matches("261283_s_at", "arabidopsis"))
        self.assertTrue(gene_id_matches("253680_at", "arabidopsis"))

        # Valid standalone numeric IDs
        self.assertTrue(gene_id_matches("267643", "arabidopsis"))

        # Invalid IDs
        self.assertFalse(gene_id_matches("9T2G21130", "arabidopsis"))
        self.assertFalse(gene_id_matches("AT2G2113X", "arabidopsis"))
        self.assertFalse(gene_id_matches("Solyc04g054700", "arabidopsis"))
        self.assertFalse(gene_id_matches("randomjunk", "arabidopsis"))

    def test_gene_id_pattern_seedcoat(self):
        """efp_seedcoat accepts AGI, ATH1 probesets, CATMA probes, and AROS probes."""
        self.assertTrue(gene_id_matches("At1g01010", "seedcoat"))
        self.assertTrue(gene_id_matches("At30023977", "seedcoat"))
        self.assertTrue(gene_id_matches("At30027789", "seedcoat"))
        self.assertTrue(gene_id_matches("A017813_01", "seedcoat"))
        self.assertTrue(gene_id_matches("A006881_01", "seedcoat"))
        self.assertFalse(gene_id_matches("randomjunk", "seedcoat"))

    def test_gene_id_pattern_barley(self):
        """efp_barley accepts barley gene IDs and Affymetrix barley probeset IDs."""
        # Probeset IDs from barley_mas and barley_rma sample data
        self.assertTrue(gene_id_matches("Contig7905_at", "barley"))
        self.assertTrue(gene_id_matches("Contig440_s_at", "barley"))
        self.assertTrue(gene_id_matches("EBro06_SQ001_B02_at", "barley"))
        self.assertTrue(gene_id_matches("HVSMEi0007J05r2_at", "barley"))
        self.assertTrue(gene_id_matches("Contig12089_at", "barley"))

        self.assertFalse(gene_id_matches("AT1G01010", "barley"))
        self.assertFalse(gene_id_matches("randomjunk", "barley"))

    def test_gene_id_pattern_rice(self):
        """efp_rice accepts canonical rice gene IDs and rice array probeset IDs."""
        self.assertTrue(gene_id_matches("LOC_Os01g01430", "rice"))
        self.assertTrue(gene_id_matches("Os.17822.2.S1_s_at", "rice"))
        self.assertTrue(gene_id_matches("OsAffx.4511.1.S1_s_at", "rice"))
        self.assertTrue(gene_id_matches("Os.12223.2.S1_at", "rice"))

        self.assertFalse(gene_id_matches("AT1G01010", "rice"))
        self.assertFalse(gene_id_matches("randomjunk", "rice"))

    def test_gene_id_pattern_medicago(self):
        """efp_medicago accepts canonical Medicago gene IDs and Medicago array probeset IDs."""
        self.assertTrue(gene_id_matches("Medtr1g018805", "medicago"))
        self.assertTrue(gene_id_matches("Mtr.44080.1.S1_at", "medicago"))
        self.assertTrue(gene_id_matches("Msa.959.1.S1_at", "medicago"))
        self.assertTrue(gene_id_matches("Sme.396.1.S1_at", "medicago"))
        # _s_at variants must also match (e.g. Mtr.50680.1.S1_s_at from medicago_rma)
        self.assertTrue(gene_id_matches("Mtr.50680.1.S1_s_at", "medicago"))

        self.assertFalse(gene_id_matches("AT1G01010", "medicago"))
        self.assertFalse(gene_id_matches("randomjunk", "medicago"))

    def test_gene_id_pattern_poplar(self):
        """efp_poplar accepts Potri gene IDs and poplar array probeset IDs."""
        self.assertTrue(gene_id_matches("Potri.019G123900.1", "poplar"))
        self.assertTrue(gene_id_matches("PtpAffx.154622.1.S1_at", "poplar"))
        self.assertTrue(gene_id_matches("PtpAffx.37687.1.S1_at", "poplar"))
        self.assertTrue(gene_id_matches("PtpAffx.202274.1.S1_s_at", "poplar"))

        self.assertFalse(gene_id_matches("AT1G01010", "poplar"))
        self.assertFalse(gene_id_matches("randomjunk", "poplar"))

    def test_gene_id_pattern_triticale(self):
        """efp_triticale accepts Ta.* and TaAffx.* probeset IDs (both occur in data)."""
        self.assertTrue(gene_id_matches("Ta.8002.1.S1_at", "triticale"))
        # TaAffx probes from triticale_test_data.json — require TaAffx prefix support
        self.assertTrue(gene_id_matches("TaAffx.54155.1.S1_at", "triticale"))
        self.assertTrue(gene_id_matches("TaAffx.6560.1.S1_at", "triticale"))
        self.assertTrue(gene_id_matches("Ta.3469.1.A1_at", "triticale"))

        self.assertFalse(gene_id_matches("randomjunk", "triticale"))
        self.assertFalse(gene_id_matches("AT1G01010", "triticale"))

    def test_gene_id_pattern_unknown_project(self):
        """Unknown eFP project returns False regardless of gene ID."""
        self.assertFalse(gene_id_matches("AT1G01010", "unknown_species"))
