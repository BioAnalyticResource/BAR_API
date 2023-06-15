from unittest import TestCase
from api.utils.bar_utils import BARUtils


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
        result = BARUtils.is_arabidopsis_gene_valid("At1g01010")
        self.assertTrue(result)
        result = BARUtils.is_arabidopsis_gene_valid("At1g01010.1")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_arabidopsis_gene_valid("abc")
        self.assertFalse(result)
        result = BARUtils.is_arabidopsis_gene_valid("At1g01010.11")
        self.assertFalse(result)

    def test_is_brassica_rapa_gene_valid(self):
        # Valid gene
        result = BARUtils.is_brassica_rapa_gene_valid("BraA01g000010")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_brassica_rapa_gene_valid("abc")
        self.assertFalse(result)

    def test_is_kalanchoe_gene_valid(self):
        # Valid gene
        result = BARUtils.is_kalanchoe_gene_valid("Kaladp0001s0001")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_kalanchoe_gene_valid("abc")
        self.assertFalse(result)

    def test_is_phelipanche_gene_valid(self):
        # Valid gene
        result = BARUtils.is_phelipanche_gene_valid("OrAeBC5_9992.10")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_phelipanche_gene_valid("abc")
        self.assertFalse(result)

    def test_is_physcomitrella_gene_valid(self):
        # Valid gene
        result = BARUtils.is_physcomitrella_gene_valid("Pp1s9_70V6.1")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_physcomitrella_gene_valid("abc")
        self.assertFalse(result)

    def test_is_selaginella_gene_valid(self):
        # Valid gene
        result = BARUtils.is_selaginella_gene_valid("Smo402070")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_selaginella_gene_valid("abc")
        self.assertFalse(result)

    def test_is_strawberry_gene_valid(self):
        # Valid gene
        result = BARUtils.is_strawberry_gene_valid("FvH4_1g00010")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_strawberry_gene_valid("abc")
        self.assertFalse(result)

    def test_is_striga_gene_valid(self):
        # Valid gene
        result = BARUtils.is_striga_gene_valid("StHeBC3_9993.10")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_striga_gene_valid("abc")
        self.assertFalse(result)

    def test_is_triphysaria_gene_valid(self):
        # Valid gene
        result = BARUtils.is_triphysaria_gene_valid("TrVeBC3_9999.18")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_triphysaria_gene_valid("abc")
        self.assertFalse(result)

    def test_is_tomato_gene_valid(self):
        # For some reason, coverage is saying that we need this test
        result = BARUtils.is_tomato_gene_valid("Solyc04g014530")
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
        result = BARUtils.is_poplar_gene_valid("Potri.019G123900.1")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_poplar_gene_valid("abc")
        self.assertFalse(result)

    def test_is_sorghum_gene_valid(self):
        # Valid gene
        result = BARUtils.is_sorghum_gene_valid("Sobic.001G000100")
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_sorghum_gene_valid("abc")
        self.assertFalse(result)

    def test_format_poplar(self):
        # Test format
        result = BARUtils.format_poplar("potri.019g123900.1")
        expected = "Potri.019G123900.1"
        self.assertEqual(result, expected)
