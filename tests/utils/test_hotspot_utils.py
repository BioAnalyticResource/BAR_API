from unittest import TestCase
from api.utils.hotspot_utils import HotspotUtils


class UtilsUnitTest(TestCase):
    def test_match_residues_equal(self):
        prot1 = "NICKPRVARTVINCENTLA"
        prot2 = "NICKPRVARTVINCENTLA"
        match = HotspotUtils.match_residues((prot1, prot2))
        self.assertEqual(len(match), len(prot1))
        for i in range(1, len(prot1) + 1):
            self.assertTrue(i in match and i == match[i])

    def test_match_residues_no_overlap(self):
        prot1 = "----------VINCENTLA"
        prot2 = "NICKPRVART---------"
        match = HotspotUtils.match_residues((prot1, prot2))
        self.assertEqual(len(match), 0)

    def test_match_residues_prot1_gap(self):
        # Protein 1 begins with gap
        prot1 = "--CKPRV-RTV-----TLA"
        prot2 = "NIC--RVA--VINCENTLA"
        match = HotspotUtils.match_residues((prot1, prot2))
        self.assertEqual(len(match), 7)
        self.assertTrue(1 in match and match[1] == 3)
        self.assertTrue(4 in match and match[4] == 4)
        self.assertTrue(5 in match and match[5] == 5)
        self.assertTrue(8 in match and match[8] == 7)
        self.assertTrue(9 in match and match[9] == 13)
        self.assertTrue(10 in match and match[10] == 14)
        self.assertTrue(11 in match and match[11] == 15)

    def test_match_residues_prot2_gap(self):
        # Protein 2 begins with gap
        prot1 = "N-CK--VAR--INCEN-L-"
        prot2 = "-I--PRVA---I--ENT-A"
        match = HotspotUtils.match_residues((prot1, prot2))
        self.assertEqual(len(match), 5)
        self.assertTrue(4 in match and match[4] == 4)
        self.assertTrue(5 in match and match[5] == 5)
        self.assertTrue(7 in match and match[7] == 6)
        self.assertTrue(10 in match and match[10] == 7)
        self.assertTrue(11 in match and match[11] == 8)

    def test_match_residues_unequal_res(self):
        # Test 4: Aligned positions with different residues
        prot1 = "NICK------VINCENT--"
        prot2 = "VINCENT---LAU------"
        match = HotspotUtils.match_residues((prot1, prot2))
        self.assertEqual(len(match), 7)
        self.assertTrue(1 in match and match[1] == 1)
        self.assertTrue(2 in match and match[2] == 2)
        self.assertTrue(3 in match and match[3] == 3)
        self.assertTrue(4 in match and match[4] == 4)
        self.assertTrue(5 in match and match[5] == 8)
        self.assertTrue(6 in match and match[6] == 9)
        self.assertTrue(7 in match and match[7] == 10)
