from unittest import TestCase
from api.utils.bar_utils import BARUtils


class UtilsUnitTest(TestCase):
    def test_error_exit(self):
        msg = 'A test error message'
        result = BARUtils.error_exit(msg)
        expected = {'wasSuccessful': False, 'error': msg}
        self.assertEqual(result, expected)

    def test_successful_exit(self):
        msg = 'A successful test message'
        result = BARUtils.success_exit(msg)
        expected = {'wasSuccessful': True, 'data': msg}
        self.assertEqual(result, expected)

    def test_is_arabidopsis_gene_valid(self):
        # Valid gene
        result = BARUtils.is_arabidopsis_gene_valid('At1g01010')
        self.assertTrue(result)
        result = BARUtils.is_arabidopsis_gene_valid('At1g01010.1')
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_arabidopsis_gene_valid('abc')
        self.assertFalse(result)
        result = BARUtils.is_arabidopsis_gene_valid('At1g01010.11')
        self.assertFalse(result)

    def test_is_integer(self):
        # Valid result
        result = BARUtils.is_integer('5')
        self.assertTrue(result)

        # Valid but too large
        result = BARUtils.is_integer('99999999999999')
        self.assertFalse(result)

        # Invalid
        result = BARUtils.is_integer('abc')
        self.assertFalse(result)

    def test_is_poplar_gene_valid(self):
        # Valid gene
        result = BARUtils.is_poplar_gene_valid('Potri.019G123900.1')
        self.assertTrue(result)

        # Invalid gene
        result = BARUtils.is_poplar_gene_valid('abc')
        self.assertFalse(result)

    def test_format_poplar(self):
        # Test format
        result = BARUtils.format_poplar('potri.019g123900.1')
        expected = 'Potri.019G123900.1'
        self.assertEqual(result, expected)
