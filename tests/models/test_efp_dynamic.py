"""
Integration tests for EFP dynamic ORM models.

Tests the dynamic ORM models work correctly with SQLAlchemy,
including column types, primary keys, and table metadata.
"""

import os
import sys
from unittest import TestCase

# Allow importing api when invoking pytest from this directory tree
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from sqlalchemy import inspect  # noqa: E402
from api import app  # noqa: E402
from api.models.efp_dynamic import SIMPLE_EFP_SAMPLE_MODELS  # noqa: E402
from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS  # noqa: E402


class TestDynamicModelColumns(TestCase):
    """Test that dynamic models have correctly typed columns."""

    def setUp(self):
        """Set up application context for each test."""
        self.ctx = app.app_context()
        self.ctx.push()

    def tearDown(self):
        """Tear down application context."""
        self.ctx.pop()

    def test_cannabis_model_columns(self):
        """Test cannabis model has correct columns and types."""
        model = SIMPLE_EFP_SAMPLE_MODELS['cannabis']

        # Check the 3 data columns
        self.assertTrue(hasattr(model, 'data_probeset_id'))
        self.assertTrue(hasattr(model, 'data_signal'))
        self.assertTrue(hasattr(model, 'data_bot_id'))

        # Inspect column types
        mapper = inspect(model)
        columns = {col.name: col for col in mapper.columns}

        self.assertEqual(len(columns), 3)
        self.assertEqual(str(columns['data_bot_id'].type), 'VARCHAR(8)')
        self.assertEqual(str(columns['data_probeset_id'].type), 'VARCHAR(24)')

    def test_mouse_db_has_3_columns(self):
        """Test mouse_db model has exactly 3 columns."""
        model = SIMPLE_EFP_SAMPLE_MODELS['mouse_db']

        # Get all columns
        mapper = inspect(model)
        column_names = {col.name for col in mapper.columns}

        # Should have exactly 3 columns
        expected = {'data_probeset_id', 'data_signal', 'data_bot_id'}
        self.assertEqual(column_names, expected)

    def test_all_models_have_3_columns(self):
        """Test all models have exactly 3 columns."""
        for db_name, model in SIMPLE_EFP_SAMPLE_MODELS.items():
            with self.subTest(database=db_name):
                mapper = inspect(model)
                column_names = {col.name for col in mapper.columns}
                self.assertEqual(
                    len(column_names), 3,
                    f"{db_name} has {len(column_names)} columns, expected 3: {column_names}"
                )


class TestDynamicModelPrimaryKeys(TestCase):
    """Test that primary keys are correctly defined."""

    def setUp(self):
        """Set up application context for each test."""
        self.ctx = app.app_context()
        self.ctx.push()

    def tearDown(self):
        """Tear down application context."""
        self.ctx.pop()

    def test_cannabis_primary_keys(self):
        """Test cannabis model has correct primary keys."""
        model = SIMPLE_EFP_SAMPLE_MODELS['cannabis']
        mapper = inspect(model)

        pk_columns = [col.name for col in mapper.primary_key]

        # Should have 3 primary keys
        self.assertEqual(len(pk_columns), 3)
        self.assertIn('data_probeset_id', pk_columns)
        self.assertIn('data_signal', pk_columns)
        self.assertIn('data_bot_id', pk_columns)

    def test_mouse_db_primary_keys(self):
        """Test mouse_db has correct primary keys."""
        model = SIMPLE_EFP_SAMPLE_MODELS['mouse_db']
        mapper = inspect(model)

        pk_columns = [col.name for col in mapper.primary_key]

        self.assertEqual(len(pk_columns), 3)
        self.assertIn('data_probeset_id', pk_columns)
        self.assertIn('data_signal', pk_columns)
        self.assertIn('data_bot_id', pk_columns)

    def test_all_models_have_primary_keys(self):
        """Test that all 191 models have at least one primary key."""
        for db_name, model in SIMPLE_EFP_SAMPLE_MODELS.items():
            with self.subTest(database=db_name):
                mapper = inspect(model)
                pk_columns = list(mapper.primary_key)

                self.assertGreater(
                    len(pk_columns), 0,
                    f"{db_name} has no primary key columns"
                )


class TestDynamicModelNullability(TestCase):
    """Test column nullable constraints."""

    def setUp(self):
        """Set up application context for each test."""
        self.ctx = app.app_context()
        self.ctx.push()

    def tearDown(self):
        """Tear down application context."""
        self.ctx.pop()

    def test_embryo_signal_nullable(self):
        """Test embryo has nullable data_signal."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['embryo']
        signal_col = next(col for col in schema['columns'] if col['name'] == 'data_signal')

        self.assertTrue(signal_col.get('nullable', False))

    def test_dna_damage_bot_id_nullable(self):
        """Test dna_damage has nullable data_bot_id."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['dna_damage']
        bot_id_col = next(col for col in schema['columns'] if col['name'] == 'data_bot_id')

        self.assertTrue(bot_id_col.get('nullable', False))

    def test_all_columns_nullable(self):
        """All 3 columns in every schema should be nullable."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            for col in schema['columns']:
                with self.subTest(database=db_name, column=col['name']):
                    self.assertTrue(
                        col.get('nullable', False),
                        f"{db_name}.{col['name']} is not nullable"
                    )


class TestDynamicModelTextColumns(TestCase):
    """Test text (tinytext) column handling."""

    def setUp(self):
        """Set up application context for each test."""
        self.ctx = app.app_context()
        self.ctx.push()

    def tearDown(self):
        """Tear down application context."""
        self.ctx.pop()

    def test_affydb_bot_id_is_text(self):
        """Test affydb has text type for data_bot_id."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['affydb']
        bot_id_col = next(col for col in schema['columns'] if col['name'] == 'data_bot_id')

        self.assertEqual(bot_id_col['type'], 'text')
        self.assertIsNone(bot_id_col.get('length'))

    def test_canola_probeset_is_text(self):
        """Test canola has text type for data_probeset_id."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['canola']
        probeset_col = next(col for col in schema['columns'] if col['name'] == 'data_probeset_id')

        self.assertEqual(probeset_col['type'], 'text')
        self.assertIsNone(probeset_col.get('length'))

    def test_canola_bot_id_is_text(self):
        """Test canola has text type for data_bot_id."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['canola']
        bot_id_col = next(col for col in schema['columns'] if col['name'] == 'data_bot_id')

        self.assertEqual(bot_id_col['type'], 'text')
        self.assertIsNone(bot_id_col.get('length'))


class TestModelClassNames(TestCase):
    """Test that model class names are generated correctly."""

    def setUp(self):
        """Set up application context for each test."""
        self.ctx = app.app_context()
        self.ctx.push()

    def tearDown(self):
        """Tear down application context."""
        self.ctx.pop()

    def test_cannabis_class_name(self):
        """Test cannabis model has correct class name."""
        model = SIMPLE_EFP_SAMPLE_MODELS['cannabis']
        self.assertEqual(model.__name__, 'CannabisSampleData')

    def test_maize_atlas_v5_class_name(self):
        """Test maize_atlas_v5 model has correct class name."""
        model = SIMPLE_EFP_SAMPLE_MODELS['maize_atlas_v5']
        self.assertEqual(model.__name__, 'MaizeAtlasV5SampleData')

    def test_lateral_root_initiation_class_name(self):
        """Test lateral_root_initiation model has correct class name."""
        model = SIMPLE_EFP_SAMPLE_MODELS['lateral_root_initiation']
        self.assertEqual(model.__name__, 'LateralRootInitiationSampleData')


class TestSampleDatabases(TestCase):
    """Test a representative sample of databases from different categories."""

    def setUp(self):
        """Set up application context for each test."""
        self.ctx = app.app_context()
        self.ctx.push()

    def tearDown(self):
        """Tear down application context."""
        self.ctx.pop()

    def test_arabidopsis_databases(self):
        """Test all arabidopsis-related databases load."""
        arabidopsis_dbs = [
            'arabidopsis_ecotypes', 'embryo', 'germination',
            'dna_damage', 'single_cell', 'silique'
        ]

        for db_name in arabidopsis_dbs:
            with self.subTest(database=db_name):
                self.assertIn(db_name, SIMPLE_EFP_SAMPLE_MODELS)
                model = SIMPLE_EFP_SAMPLE_MODELS[db_name]
                self.assertIsNotNone(model)

    def test_cereal_databases(self):
        """Test cereal crop databases (wheat, barley, rice, maize, sorghum, oat)."""
        cereal_dbs = [
            'wheat', 'barley_seed', 'rice_root',
            'maize_atlas_v5', 'sorghum_atlas_w_BS_cells', 'oat'
        ]

        for db_name in cereal_dbs:
            with self.subTest(database=db_name):
                self.assertIn(db_name, SIMPLE_EFP_SAMPLE_MODELS)
                model = SIMPLE_EFP_SAMPLE_MODELS[db_name]
                self.assertIsNotNone(model)

    def test_legume_databases(self):
        """Test legume databases (soybean, medicago, lupin)."""
        legume_dbs = [
            'soybean_senescence', 'medicago_root',
            'lupin_whole_plant', 'arachis'
        ]

        for db_name in legume_dbs:
            with self.subTest(database=db_name):
                self.assertIn(db_name, SIMPLE_EFP_SAMPLE_MODELS)
                model = SIMPLE_EFP_SAMPLE_MODELS[db_name]
                self.assertIsNotNone(model)

    def test_tree_databases(self):
        """Test tree/woody plant databases (poplar, spruce, eucalyptus)."""
        tree_dbs = ['poplar_hormone', 'spruce', 'eucalyptus', 'willow']

        for db_name in tree_dbs:
            with self.subTest(database=db_name):
                self.assertIn(db_name, SIMPLE_EFP_SAMPLE_MODELS)
                model = SIMPLE_EFP_SAMPLE_MODELS[db_name]
                self.assertIsNotNone(model)

    def test_tropical_crop_databases(self):
        """Test tropical crop databases (cacao, cassava, mangosteen)."""
        tropical_dbs = [
            'cacao_developmental_atlas', 'cassava_atlas',
            'mangosteen_fruit_ripening'
        ]

        for db_name in tropical_dbs:
            with self.subTest(database=db_name):
                self.assertIn(db_name, SIMPLE_EFP_SAMPLE_MODELS)
                model = SIMPLE_EFP_SAMPLE_MODELS[db_name]
                self.assertIsNotNone(model)
