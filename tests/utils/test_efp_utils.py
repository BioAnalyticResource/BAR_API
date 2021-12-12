from unittest import TestCase
from api.utils.efp_utils import eFPUtils


class UtilsUnitTest(TestCase):
    def test_is_efp_input_valid(self):
        """Tests for eFP input data"""

        # eFP Arabidopsis compare mode
        result = eFPUtils.is_efp_input_valid(
            "efp_arabidopsis", "Root", "Compare", "At1g01010", "At1g01030"
        )
        self.assertTrue(result[0])
        self.assertIsNone(result[1])

        result = eFPUtils.is_efp_input_valid(
            "efp_arabidopsis", "Root", "Compare", "At1g01010", "Abc"
        )
        expected = "Gene 2 is invalid."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)

        # eFP Cannabis gene1
        result = eFPUtils.is_efp_input_valid(
            "efp_cannabis", "Cannabis_Atlas", "Absolute", "AGQN03000001"
        )
        self.assertTrue(result[0])
        self.assertIsNone(result[1])

        result = eFPUtils.is_efp_input_valid(
            "efp_cannabis", "Cannabis_Atlas", "Absolute", "Abc"
        )
        expected = "Gene 1 is invalid."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)

        # eFP Cannabis gene2
        result = eFPUtils.is_efp_input_valid(
            "efp_cannabis", "Cannabis_Atlas", "Compare", "AGQN03000001", "AGQN03000012"
        )
        self.assertTrue(result[0])
        self.assertIsNone(result[1])

        result = eFPUtils.is_efp_input_valid(
            "efp_cannabis", "Cannabis_Atlas", "Compare", "AGQN03000001", "Abc"
        )
        expected = "Gene 2 is invalid."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)
