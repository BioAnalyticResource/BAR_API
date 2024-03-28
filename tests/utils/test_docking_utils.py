import unittest
import pytest
from api.utils.docking_utils import Receptor, ComplexReceptor, MonomerReceptor
from api.utils.docking_utils import Ligand
from api.utils.docking_utils import Docker
from api.utils.docking_utils import MonomerDocking, ComplexDocking
import os

IN_CI = os.getenv("CI") == "true"

class TestReceptorClasses(unittest.TestCase):

    def test_monomer_receptor_init(self):
        """Test that MonomerReceptor object is correctly instantiated."""

        monomer_receptor = MonomerReceptor("AT9G99999", "/tests/data/AF2_AT9G99999_monomer.pdb")
        self.assertEqual(monomer_receptor.name, "AT9G99999")
        self.assertEqual(monomer_receptor.file_path, "/tests/data/AF2_AT9G99999_monomer.pdb")

    def test_complex_receptor_init(self):
        """Test that ComplexReceptor object is correctly instantiated. This
        function also tests that monomers are separated correctly using
        separate_monomers when the object is instantiated.
        """

        monomers_list = ["A", "B"]
        complex_receptor = ComplexReceptor("test_complex_receptor",
                                           "tests/data/AF2_AT8G88888_complex.pdb",
                                           monomers_list)
        self.assertEqual(complex_receptor.name, "test_complex_receptor")
        self.assertEqual(complex_receptor.file_path, "tests/data/AF2_AT8G88888_complex.pdb")
        self.assertEqual(complex_receptor.monomers_list, monomers_list)
        self.assertEqual(len(complex_receptor.line_numbers), len(monomers_list))
        self.assertEqual(complex_receptor.line_numbers, [[48, 180], [181, 195]])


class TestLigandClass(unittest.TestCase):

    def test_ligand_init(self):
        """Test that Ligand object is correctly instantiated."""

        ligand = Ligand("test_ligand", "tests/data/6325_Ethylene.sdf")
        self.assertEqual(ligand.name, "test_ligand")
        self.assertEqual(ligand.file_path, "tests/data/6325_Ethylene.sdf")


class TestDockerClass(unittest.TestCase):

    def test_create_monomer_receptor(self):
        """Test that docker creates a MonomerReceptor object when given a
        monomer pdb file."""

        receptor_name = "AT9G99999_monomer"
        receptor_path = "tests/data/AF2_AT9G99999_monomer.pdb"
        receptor = Docker.create_receptor(receptor_name, receptor_path)
        self.assertEqual(isinstance(receptor, MonomerReceptor), True)
        self.assertEqual(receptor.name, receptor_name)
        self.assertEqual(receptor.file_path, receptor_path)

    def test_create_complex_receptor(self):
        """Test that docker creates a correct ComplexReceptor object when
        given a complex pdb file."""

        receptor_name = "AT8G88888_complex"
        receptor_path = "tests/data/AF2_AT8G88888_complex.pdb"
        receptor = Docker.create_receptor(receptor_name, receptor_path)
        self.assertEqual(isinstance(receptor, Receptor), True)
        self.assertEqual(receptor.name, "AT8G88888_complex")
        self.assertEqual(receptor.file_path, "tests/data/AF2_AT8G88888_complex.pdb")
        self.assertEqual(receptor.monomers_list, ["A", "B"])
        self.assertEqual(receptor.line_numbers, [[48, 180], [181, 195]])

    @pytest.mark.skipif(IN_CI, reason = "Doesn't work in Github CI")
    def test_docking_exists(self):
        """Test that Docker.create_docking returns None when the docking
        already exists."""

        receptor_name = "AT1G66340"
        ligand_name = "6325_Ethylene"
        results_path = "tests/data/"
        docking = Docker.create_docking(receptor_name, ligand_name, results_path)
        self.assertEqual(docking[0], None)


class TestDockingClass(unittest.TestCase):

    def test_docking_complex_results(self):
        """Test that correct dictionary is created in normalized_results for
        complex docking."""

        receptor_name = "AT8G88888_complex"
        receptor_path = "tests/data/AF2_AT8G88888_complex.pdb"
        ligand_name = "6325_Ethylene"
        ligand_path = "tests/data/6325_Ethylene.sdf"
        results_path = "tests/data/AT8G88888_complex_6325_Ethylene/"
        receptor = Docker.create_receptor(receptor_name, receptor_path)
        ligand = Ligand(ligand_name, ligand_path)
        docking = ComplexDocking(receptor, ligand, results_path)
        docking.separate_results()
        docking.crte_ligand_reserved_attr()
        normalized_results = docking.normalize_results(5)

        self.assertIsInstance(normalized_results, dict)
        self.assertIsNot(len(normalized_results), 0)
        self.assertIn('AT8G88888_complex_A', normalized_results)
        self.assertIn('AT8G88888_complex_B', normalized_results)
        self.assertIn('6325_Ethylene', normalized_results['AT8G88888_complex_A'])
        self.assertIn('6325_Ethylene', normalized_results['AT8G88888_complex_B'])

    def test_docking_monomer_results(self):
        """Test that correct dictionary is created in normalized_results for
        monomer docking."""

        receptor_name = "AT9G99999_monomer"
        receptor_path = "tests/data/AF2_AT9G99999_monomer.pdb"
        ligand_name = "6325_Ethylene"
        ligand_path = "tests/data/6325_Ethylene.sdf"
        results_path = "tests/data/AT9G99999_monomer_6325_Ethylene/"
        receptor = Docker.create_receptor(receptor_name, receptor_path)
        ligand = Ligand(ligand_name, ligand_path)
        docking = MonomerDocking(receptor, ligand, results_path)
        docking.crte_ligand_reserved_attr()
        normalized_results = docking.normalize_results(5)

        self.assertIsInstance(normalized_results, dict)
        self.assertIsNot(len(normalized_results), 0)
        self.assertIn('AT9G99999_monomer', normalized_results)
        self.assertIn('6325_Ethylene', normalized_results['AT9G99999_monomer'])


if __name__ == '__main__':
    unittest.main()
