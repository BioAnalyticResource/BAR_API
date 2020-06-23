from unittest import TestCase
from api.utilities.bar_utilites import BARUtilities


class UtilsUnitTest(TestCase):
    def test_error_exit(self):
        msg = 'A test error message'
        result = BARUtilities.error_exit(msg)
        expected = {'success': False, 'error': msg}
        self.assertEqual(result, expected)

    def test_success_exit(self):
        msg = 'A success test message'
        result = BARUtilities.success_exit(msg)
        expected = result = {'success': True, 'data': msg}
        self.assertEqual(result, expected)
