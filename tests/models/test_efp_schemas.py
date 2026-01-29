"""
Comprehensive tests for EFP database schemas and dynamic ORM generation.

Tests all 191 EFP databases to ensure:
1. Schema definitions are valid
2. Dynamic ORM models generate correctly
3. Column types and constraints are properly configured
4. Complex schemas (lateral_root_initiation, mouse_db, oat) work correctly
"""

import os
import sys
from unittest import TestCase

# Allow importing api when invoking pytest from this directory tree
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from api import app
from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS, EfpSchemaBuilder
from api.models.efp_dynamic import SIMPLE_EFP_SAMPLE_MODELS


class TestEfpSchemaDefinitions(TestCase):
    """Test all 191 EFP database schema definitions."""

    def test_all_191_databases_loaded(self):
        """Verify all 191 databases from CSV are loaded."""
        self.assertEqual(
            len(SIMPLE_EFP_DATABASE_SCHEMAS),
            191,
            f"Expected 191 databases, found {len(SIMPLE_EFP_DATABASE_SCHEMAS)}"
        )

    def test_all_schemas_have_required_keys(self):
        """Every schema must have table_name, charset, columns, index, and metadata."""
        required_keys = {'table_name', 'charset', 'columns', 'index', 'metadata'}

        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                missing_keys = required_keys - set(schema.keys())
                self.assertEqual(
                    len(missing_keys), 0,
                    f"{db_name} missing required keys: {missing_keys}"
                )

    def test_all_schemas_have_metadata(self):
        """Every schema must have species and sample_regex metadata."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                metadata = schema.get('metadata', {})
                self.assertIn('species', metadata, f"{db_name} missing species metadata")
                self.assertIn('sample_regex', metadata, f"{db_name} missing sample_regex metadata")

    def test_all_schemas_have_base_columns(self):
        """Most databases should have the 5 base columns (except mouse_db which has only 3)."""
        base_column_names = {'proj_id', 'sample_id', 'data_probeset_id', 'data_signal', 'data_bot_id'}

        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                column_names = {col['name'] for col in schema['columns']}

                # mouse_db is special - only has 3 columns
                if db_name == 'mouse_db':
                    expected = {'data_probeset_id', 'data_signal', 'data_bot_id'}
                    self.assertTrue(
                        expected.issubset(column_names),
                        f"{db_name} missing expected columns. Has: {column_names}"
                    )
                # lateral_root_initiation has project_id instead of proj_id
                elif db_name == 'lateral_root_initiation':
                    expected = {'sample_id', 'data_probeset_id', 'data_signal', 'data_bot_id', 'project_id'}
                    self.assertTrue(
                        expected.issubset(column_names),
                        f"{db_name} missing expected columns. Has: {column_names}"
                    )
                else:
                    # Standard databases should have all 5 base columns
                    self.assertTrue(
                        base_column_names.issubset(column_names),
                        f"{db_name} missing base columns. Has: {column_names}"
                    )

    def test_column_types_are_valid(self):
        """All column types must be one of: string, integer, float, text."""
        valid_types = {'string', 'integer', 'float', 'text'}

        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            for column in schema['columns']:
                with self.subTest(database=db_name, column=column['name']):
                    col_type = column.get('type')
                    self.assertIn(
                        col_type, valid_types,
                        f"{db_name}.{column['name']} has invalid type: {col_type}"
                    )

    def test_string_columns_have_length(self):
        """String columns must have a length specified."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            for column in schema['columns']:
                with self.subTest(database=db_name, column=column['name']):
                    if column.get('type') == 'string':
                        self.assertIn(
                            'length', column,
                            f"{db_name}.{column['name']} is string but missing length"
                        )
                        self.assertIsInstance(
                            column['length'], int,
                            f"{db_name}.{column['name']} length must be int"
                        )
                        self.assertGreater(
                            column['length'], 0,
                            f"{db_name}.{column['name']} length must be > 0"
                        )

    def test_text_columns_have_no_length(self):
        """Text columns should not have a length."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            for column in schema['columns']:
                with self.subTest(database=db_name, column=column['name']):
                    if column.get('type') == 'text':
                        length = column.get('length')
                        self.assertIsNone(
                            length,
                            f"{db_name}.{column['name']} is text but has length={length}"
                        )

    def test_charset_is_valid(self):
        """Charset must be either latin1 or utf8mb4."""
        valid_charsets = {'latin1', 'utf8mb4'}

        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                charset = schema.get('charset')
                self.assertIn(
                    charset, valid_charsets,
                    f"{db_name} has invalid charset: {charset}"
                )

    def test_known_databases_have_correct_species(self):
        """Verify species metadata for known databases."""
        known_species = {
            'cannabis': 'cannabis',
            'embryo': 'arabidopsis',
            'wheat': 'wheat',
            'maize_atlas_v5': 'maize',
            'rice_root': 'rice',
            'sorghum_atlas_w_BS_cells': 'sorghum',
            'oat': 'oat',
            'mouse_db': 'mouse',
        }

        for db_name, expected_species in known_species.items():
            with self.subTest(database=db_name):
                schema = SIMPLE_EFP_DATABASE_SCHEMAS.get(db_name)
                self.assertIsNotNone(schema, f"{db_name} not found in schemas")
                actual_species = schema['metadata']['species']
                self.assertEqual(
                    actual_species, expected_species,
                    f"{db_name} has species={actual_species}, expected {expected_species}"
                )

    def test_primary_keys_are_defined(self):
        """Each schema should have at least one primary key column."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                pk_columns = [col['name'] for col in schema['columns'] if col.get('primary_key')]
                self.assertGreater(
                    len(pk_columns), 0,
                    f"{db_name} has no primary key columns"
                )


class TestDynamicOrmGeneration(TestCase):
    """Test dynamic ORM model generation for all databases."""

    def setUp(self):
        """Set up application context for each test."""
        self.ctx = app.app_context()
        self.ctx.push()

    def tearDown(self):
        """Tear down application context."""
        self.ctx.pop()

    def test_all_191_models_generated(self):
        """Verify all 191 dynamic ORM models are generated."""
        self.assertEqual(
            len(SIMPLE_EFP_SAMPLE_MODELS),
            191,
            f"Expected 191 ORM models, found {len(SIMPLE_EFP_SAMPLE_MODELS)}"
        )

    def test_model_names_match_database_names(self):
        """ORM model keys should match schema keys."""
        schema_names = set(SIMPLE_EFP_DATABASE_SCHEMAS.keys())
        model_names = set(SIMPLE_EFP_SAMPLE_MODELS.keys())

        self.assertEqual(
            schema_names, model_names,
            f"Mismatch between schemas and models. Missing: {schema_names - model_names}"
        )

    def test_all_models_have_tablename(self):
        """Every model must have __tablename__ attribute."""
        for db_name, model in SIMPLE_EFP_SAMPLE_MODELS.items():
            with self.subTest(database=db_name):
                self.assertTrue(
                    hasattr(model, '__tablename__'),
                    f"{db_name} model missing __tablename__"
                )
                self.assertEqual(
                    model.__tablename__, 'sample_data',
                    f"{db_name} has wrong table name"
                )

    def test_all_models_have_bind_key(self):
        """Every model must have __bind_key__ matching the database name."""
        for db_name, model in SIMPLE_EFP_SAMPLE_MODELS.items():
            with self.subTest(database=db_name):
                self.assertTrue(
                    hasattr(model, '__bind_key__'),
                    f"{db_name} model missing __bind_key__"
                )
                self.assertEqual(
                    model.__bind_key__, db_name,
                    f"{db_name} has wrong bind_key"
                )

    def test_models_have_correct_column_count(self):
        """Models should have the same number of columns as their schema."""
        for db_name, model in SIMPLE_EFP_SAMPLE_MODELS.items():
            with self.subTest(database=db_name):
                schema = SIMPLE_EFP_DATABASE_SCHEMAS[db_name]
                expected_cols = len(schema['columns'])

                # Count actual columns (excluding internal attributes)
                actual_cols = len([
                    attr for attr in dir(model)
                    if not attr.startswith('_') and
                    hasattr(getattr(model, attr), 'type')
                ])

                self.assertEqual(
                    actual_cols, expected_cols,
                    f"{db_name} model has {actual_cols} columns, schema has {expected_cols}"
                )

    def test_known_models_have_expected_columns(self):
        """Verify specific models have their expected columns."""
        test_cases = {
            'cannabis': ['proj_id', 'sample_id', 'data_probeset_id', 'data_signal', 'data_bot_id'],
            'oat': ['proj_id', 'sample_id', 'data_probeset_id', 'data_signal', 'data_bot_id',
                    'genome', 'genome_id', 'orthogroup', 'version'],
            'mouse_db': ['data_probeset_id', 'data_signal', 'data_bot_id'],
        }

        for db_name, expected_columns in test_cases.items():
            with self.subTest(database=db_name):
                model = SIMPLE_EFP_SAMPLE_MODELS[db_name]
                for col_name in expected_columns:
                    self.assertTrue(
                        hasattr(model, col_name),
                        f"{db_name} model missing column: {col_name}"
                    )


class TestComplexSchemas(TestCase):
    """Test the 3 complex/non-standard schemas."""

    def test_lateral_root_initiation_has_project_id(self):
        """lateral_root_initiation has both project_id and sample_file_name as extra columns."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['lateral_root_initiation']
        column_names = {col['name'] for col in schema['columns']}

        # Has the extra project_id column
        self.assertIn('project_id', column_names)
        # Also has standard proj_id from base columns
        self.assertIn('proj_id', column_names)
        # Has sample_file_name extra column
        self.assertIn('sample_file_name', column_names)

    def test_lateral_root_initiation_has_string_sample_id(self):
        """lateral_root_initiation has string sample_id instead of integer."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['lateral_root_initiation']
        sample_id_col = next(col for col in schema['columns'] if col['name'] == 'sample_id')

        self.assertEqual(sample_id_col['type'], 'string')
        self.assertEqual(sample_id_col['length'], 30)

    def test_mouse_db_has_minimal_columns(self):
        """mouse_db has the 3 main data columns (still includes base proj_id/sample_id from template)."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['mouse_db']
        column_names = {col['name'] for col in schema['columns']}

        # Has the 3 data columns
        self.assertIn('data_probeset_id', column_names)
        self.assertIn('data_signal', column_names)
        self.assertIn('data_bot_id', column_names)

        # Should have 5 columns total (includes base proj_id and sample_id)
        self.assertEqual(len(column_names), 5)

    def test_oat_has_extra_genome_columns(self):
        """oat has 4 extra columns: genome, genome_id, orthogroup, version."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['oat']
        column_names = {col['name'] for col in schema['columns']}

        extra_columns = {'genome', 'genome_id', 'orthogroup', 'version'}
        self.assertTrue(
            extra_columns.issubset(column_names),
            f"oat missing expected extra columns"
        )

    def test_oat_has_utf8mb4_charset(self):
        """oat uses utf8mb4 charset."""
        schema = SIMPLE_EFP_DATABASE_SCHEMAS['oat']
        self.assertEqual(schema['charset'], 'utf8mb4')


class TestSchemaBuilderHelpers(TestCase):
    """Test the schema builder helper methods."""

    def test_simple_schema_creates_valid_schema(self):
        """_simple_schema helper should create a valid schema structure."""
        schema = EfpSchemaBuilder._simple_schema(
            species='test_species',
            sample_regex=r'.*',
            probeset_len=24,
            bot_id_len=16,
        )

        self.assertIn('table_name', schema)
        self.assertIn('columns', schema)
        self.assertIn('metadata', schema)
        self.assertEqual(schema['metadata']['species'], 'test_species')

    def test_schema_with_qa_columns_adds_three_columns(self):
        """_schema_with_qa_columns should add sample_file_name, data_call, data_p_val."""
        schema = EfpSchemaBuilder._schema_with_qa_columns(
            species='test_species',
            sample_regex=r'.*',
        )

        column_names = {col['name'] for col in schema['columns']}
        qa_columns = {'sample_file_name', 'data_call', 'data_p_val'}

        self.assertTrue(
            qa_columns.issubset(column_names),
            f"QA schema missing QA columns"
        )

    def test_build_schema_handles_extra_columns(self):
        """_build_schema should properly merge extra columns."""
        extra_cols = [
            EfpSchemaBuilder._column('test_col', 'string', length=10)
        ]

        schema = EfpSchemaBuilder._build_schema(
            extra_columns=extra_cols,
            metadata={'species': 'test', 'sample_regex': r'.*'}
        )

        column_names = {col['name'] for col in schema['columns']}
        self.assertIn('test_col', column_names)


class TestDatabaseCategoryDistribution(TestCase):
    """Test distribution of databases by species and type."""

    def test_species_distribution(self):
        """Verify we have databases for expected species."""
        species_counts = {}
        for schema in SIMPLE_EFP_DATABASE_SCHEMAS.values():
            species = schema['metadata']['species']
            species_counts[species] = species_counts.get(species, 0) + 1

        # Check we have major species covered
        major_species = ['arabidopsis', 'maize', 'wheat', 'rice', 'sorghum']
        for species in major_species:
            with self.subTest(species=species):
                self.assertIn(
                    species, species_counts,
                    f"No databases found for {species}"
                )
                self.assertGreater(
                    species_counts[species], 0,
                    f"Expected databases for {species}"
                )

    def test_charset_distribution(self):
        """Verify charset distribution (should have both latin1 and utf8mb4)."""
        charset_counts = {}
        for schema in SIMPLE_EFP_DATABASE_SCHEMAS.values():
            charset = schema['charset']
            charset_counts[charset] = charset_counts.get(charset, 0) + 1

        # Should have both charsets
        self.assertIn('latin1', charset_counts)
        self.assertIn('utf8mb4', charset_counts)

        # utf8mb4 should be more common (126 databases)
        self.assertGreater(
            charset_counts['utf8mb4'], 100,
            f"Expected ~126 utf8mb4 databases, found {charset_counts['utf8mb4']}"
        )

    def test_qa_column_distribution(self):
        """Verify we have databases with and without QA columns."""
        with_qa = 0
        without_qa = 0

        for schema in SIMPLE_EFP_DATABASE_SCHEMAS.values():
            column_names = {col['name'] for col in schema['columns']}
            if 'sample_file_name' in column_names:
                with_qa += 1
            else:
                without_qa += 1

        # Should have both types
        self.assertGreater(with_qa, 0, "No databases with QA columns found")
        self.assertGreater(without_qa, 0, "No databases without QA columns found")

        # Most should be without QA columns
        self.assertGreater(without_qa, with_qa, "Expected more non-QA databases")


class TestVarcharLengths(TestCase):
    """Test that varchar lengths are within expected ranges."""

    def test_data_bot_id_max_length(self):
        """data_bot_id varchar should not exceed 255."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            bot_id_col = next(
                (col for col in schema['columns'] if col['name'] == 'data_bot_id'),
                None
            )
            if bot_id_col and bot_id_col['type'] == 'string':
                with self.subTest(database=db_name):
                    self.assertLessEqual(
                        bot_id_col['length'], 255,
                        f"{db_name}.data_bot_id length exceeds 255"
                    )

    def test_data_probeset_id_max_length(self):
        """data_probeset_id varchar should not exceed 100."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            probeset_col = next(
                (col for col in schema['columns'] if col['name'] == 'data_probeset_id'),
                None
            )
            if probeset_col and probeset_col['type'] == 'string':
                with self.subTest(database=db_name):
                    self.assertLessEqual(
                        probeset_col['length'], 100,
                        f"{db_name}.data_probeset_id length exceeds 100"
                    )

    def test_proj_id_max_length(self):
        """proj_id varchar should not exceed 30."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            proj_id_col = next(
                (col for col in schema['columns'] if col['name'] == 'proj_id'),
                None
            )
            if proj_id_col and proj_id_col['type'] == 'string':
                with self.subTest(database=db_name):
                    self.assertLessEqual(
                        proj_id_col['length'], 30,
                        f"{db_name}.proj_id length exceeds 30"
                    )
