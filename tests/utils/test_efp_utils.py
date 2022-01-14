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

        # eFP Arachis Absolute
        result = eFPUtils.is_efp_input_valid(
            "efp_arachis", "Arachis_Atlas", "Absolute", "Adur10002_comp0_c0_seq1"
        )
        self.assertTrue(result[0])
        self.assertIsNone(result[1])

        result = eFPUtils.is_efp_input_valid(
            "efp_arachis", "Arachis_Atlas", "Absolute", "Abc"
        )
        expected = "Gene 1 is invalid."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)

        # eFP Arachis gene 2
        result = eFPUtils.is_efp_input_valid(
            "efp_arachis",
            "Arachis_Atlas",
            "Compare",
            "Adur10002_comp0_c0_seq1",
            "Adur10002_comp0_c0_seq11",
        )
        self.assertTrue(result[0])
        self.assertIsNone(result[1])

        result = eFPUtils.is_efp_input_valid(
            "efp_arachis", "Arachis_Atlas", "Compare", "Adur10002_comp0_c0_seq1", "Abc"
        )
        expected = "Gene 2 is invalid."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)

        # eFP Soybean Absolute
        result = eFPUtils.is_efp_input_valid(
            "efp_soybean", "soybean", "Absolute", "Glyma06g47400"
        )
        self.assertTrue(result[0])
        self.assertIsNone(result[1])

        result = eFPUtils.is_efp_input_valid(
            "efp_soybean", "soybean", "Absolute", "Abc"
        )
        expected = "Gene 1 is invalid."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)

        # eFP Soybean gene 2
        result = eFPUtils.is_efp_input_valid(
            "efp_soybean",
            "soybean",
            "Compare",
            "Glyma06g47400",
            "Glyma06g47390",
        )
        self.assertTrue(result[0])
        self.assertIsNone(result[1])

        result = eFPUtils.is_efp_input_valid(
            "efp_soybean", "soybean", "Compare", "Glyma06g47400", "Abc"
        )
        expected = "Gene 2 is invalid."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)

        # Test if both gene are the same in eFP Comare mode
        result = eFPUtils.is_efp_input_valid(
            "efp_arachis",
            "Arachis_Atlas",
            "Compare",
            "Adur10002_comp0_c0_seq1",
            "Adur10002_comp0_c0_seq1",
        )
        expected = "In compare mode, both genes should be different."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)

        # eFP Maize Absolute
        result = eFPUtils.is_efp_input_valid(
            "efp_maize", "maize_iplant", "Absolute", "Zm00001d046170"
        )
        self.assertTrue(result[0])
        self.assertIsNone(result[1])

        result = eFPUtils.is_efp_input_valid(
            "efp_maize", "maize_iplant", "Absolute", "Abc"
        )
        expected = "Gene 1 is invalid."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)

        # eFP Maize gene 2
        result = eFPUtils.is_efp_input_valid(
            "efp_maize",
            "maize_iplant",
            "Compare",
            "Zm00001d046170",
            "Zm00001d014297",
        )
        self.assertTrue(result[0])
        self.assertIsNone(result[1])

        result = eFPUtils.is_efp_input_valid(
            "efp_maize", "maize_iplant", "Compare", "Zm00001d046170", "Abc"
        )
        expected = "Gene 2 is invalid."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)

        # Test if both gene are the same in eFP Comare mode
        result = eFPUtils.is_efp_input_valid(
            "efp_arachis",
            "Arachis_Atlas",
            "Compare",
            "Adur10002_comp0_c0_seq1",
            "Adur10002_comp0_c0_seq1",
        )
        expected = "In compare mode, both genes should be different."
        self.assertFalse(result[0])
        self.assertEqual(result[1], expected)
