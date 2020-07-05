from unittest import TestCase
from api.utilities.bar_utilities import BARUtilities


class UtilsUnitTest(TestCase):
    def test_error_exit(self):
        msg = 'A test error message'
        result = BARUtilities.error_exit(msg)
        expected = {'wasSuccessful': False, 'error': msg}
        self.assertEqual(result, expected)

    def test_successful_exit(self):
        msg = 'A successful test message'
        result = BARUtilities.success_exit(msg)
        expected = {'wasSuccessful': True, 'data': msg}
        self.assertEqual(result, expected)
