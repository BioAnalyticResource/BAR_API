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
        # Invalid gene
        result = BARUtils.is_arabidopsis_gene_valid('abc')
        self.assertFalse(result)
