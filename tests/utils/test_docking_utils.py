import unittest
import pytest
from api.utils.docking_utils import Receptor, ComplexReceptor, MonomerReceptor
from api.utils.docking_utils import Ligand
from api.utils.docking_utils import Docker
from api.utils.docking_utils import Docking, MonomerDocking, ComplexDocking
from api.utils.docking_utils import SDFMapping
import os


NOT_IN_BAR = not os.environ.get("BAR") == "true"


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
        complex_receptor = ComplexReceptor(
            "test_complex_receptor", "tests/data/AF2_AT8G88888_complex.pdb", monomers_list
        )
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

    @pytest.mark.skipif(NOT_IN_BAR, reason="Only works on BAR")
    def test_create_valid_docking(self):
        """Test that the Docking instance is correct."""

        receptor = "AT4G36360"
        ligand = "443454_Gibberellin_A24"
        docking = Docker.create_docking(receptor, ligand, "tests/data/")

        self.assertIsInstance(docking, Docking)

    @pytest.mark.skipif(NOT_IN_BAR, reason="Only works on BAR")
    def test_create_docking_invalid_receptor(self):
        """Test that invalid receptor returns an error message."""

        receptor = "AT9G99999"
        ligand = "443454_Gibberellin_A24"
        docking = Docker.create_docking(receptor, ligand, "tests/data/")

        self.assertEqual(docking, "Receptor file not found")

    @pytest.mark.skipif(NOT_IN_BAR, reason="Only works on BAR")
    def test_create_docking_invalid_ligand(self):
        """Test that invalid ligand returns an error message"""
        receptor = "AT4G36360"
        ligand = "ABCD"
        docking = Docker.create_docking(receptor, ligand, "tests/data/")

        self.assertEqual(docking, "Ligand file not found")

    @pytest.mark.skipif(NOT_IN_BAR, reason="Only works on BAR")
    def test_docking_exists(self):
        """Test that Docker.create_docking returns None when the docking
        already exists."""

        receptor_name = "AT1G66340"
        ligand_name = "6325_Ethylene"
        results_path = "tests/data/"
        docking = Docker.create_docking(receptor_name, ligand_name, results_path)
        self.assertEqual(docking[0], None)


class TestDockingClass(unittest.TestCase):

    @pytest.mark.skip(reason="Changed data infrastructure of holding PDB files, links no longer work, will fix later with Asher")
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
        self.assertIn("AT8G88888_complex_A", normalized_results)
        self.assertIn("AT8G88888_complex_B", normalized_results)
        self.assertIn("6325_Ethylene", normalized_results["AT8G88888_complex_A"])
        self.assertIn("6325_Ethylene", normalized_results["AT8G88888_complex_B"])

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
        self.assertIn("AT9G99999_monomer", normalized_results)
        self.assertIn("6325_Ethylene", normalized_results["AT9G99999_monomer"])


class TestSDFMappingClass(unittest.TestCase):

    @pytest.mark.skipif(NOT_IN_BAR, reason="Only works on BAR")
    def test_create_mapping_filtered(self):
        """Test that the correct mapping is returned"""

        mapping_results = SDFMapping.create_mapping_filtered("tests/data/sample_ligands/filtered/", "tests/data/")
        correct_mapping = [
            {"value": "443453_Gibberellin_A15.sdf", "text": "Gibberellin_A15"},
            {"value": "5984_D-(-)-Fructose.sdf", "text": "D-(-)-Fructose"},
            {"value": "801_Auxin.sdf", "text": "Auxin"},
            {"value": "73672_isoxaben.sdf", "text": "isoxaben"},
        ]
        self.assertEqual(mapping_results, correct_mapping)
        self.assertTrue(os.path.exists("tests/data/sdf_mapping_filtered.json"))
        if os.path.exists("tests/data/sdf_mapping_filtered.json"):
            os.remove("tests/data/sdf_mapping_filtered.json")

    @pytest.mark.skipif(NOT_IN_BAR, reason="Only works on BAR")
    def test_create_mapping_unfiltered(self):
        """Test that the correct mapping is returned"""
        mapping = SDFMapping()
        mapping_results = mapping.create_mapping_unfiltered("tests/data/sample_ligands/unfiltered/", "tests/data/")
        correct_mapping = [
            {"value": "135355153.sdf", "text": "F II (sugar fraction),LK41100000,NIOSH/LK4110000"},
            {
                "value": "134970870.sdf",
                "text": "10597-68-9,149014-33-5,196419-06-4,3812-57-5,57-48-7,69-67-0,AI3-23514,Advantose FS 95,CCRIS 3335,D-(-)-Fructose,D-(-)-Levulose,D-Fructose,EINECS 200-333-3,Fructose,Fructose solution,Fructose, D-,Fructose, pure,Fruit sugar,Furucton,Hi-Fructo 970,Krystar 300,Levulose,Nevulose,Sugar, fruit,UNII-6YSS42VSEV,arabino-Hexulose",
            },
            {"value": "103061392.sdf", "text": "C18210,Chorionic somatomammotropin hormone,PL,Placental lactogen"},
            {
                "value": "135191341.sdf",
                "text": "73684-80-7,L-Leucinamide, 5-oxo-L-prolyl-L-seryl-,Pyr-ser-leu-NH2,Pyro-gln-ser-leu-amide,Pyroglutamine-serine-leucinamide,Pyroglutaminyl-seryl-leucinamide,Pyroglutamylserylleucinamide,Thyrotropin releasing hormone-AN,Trh-AN",
            },
        ]
        self.assertEqual(mapping_results, correct_mapping)
        self.assertTrue(os.path.exists("tests/data/sdf_mapping_unfiltered.json"))
        if os.path.exists("tests/data/sdf_mapping_unfiltered.json"):
            os.remove("tests/data/sdf_mapping_unfiltered.json")
