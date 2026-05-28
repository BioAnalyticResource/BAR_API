"""
Comprehensive tests for EFP database schemas and dynamic ORM generation.

Tests all 191 EFP databases to ensure:
1. Schema definitions are valid
2. Dynamic ORM models generate correctly
3. Column types and constraints are properly configured
"""

import os
import sys
from unittest import TestCase

# Allow importing api when invoking pytest from this directory tree
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from api import app  # noqa: E402
from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS  # noqa: E402
from api.models.efp_dynamic import SIMPLE_EFP_SAMPLE_MODELS  # noqa: E402


class TestEfpSchemaDefinitions(TestCase):
    """Test all 191 EFP database schema definitions."""

    def test_all_191_databases_loaded(self):
        """Verify all 191 databases from CSV are loaded."""
        self.assertEqual(
            len(SIMPLE_EFP_DATABASE_SCHEMAS), 191, f"Expected 191 databases, found {len(SIMPLE_EFP_DATABASE_SCHEMAS)}"
        )

    def test_all_schemas_have_required_keys(self):
        """Every schema must have table_name, charset, columns, index, and metadata."""
        required_keys = {"table_name", "charset", "columns", "index", "metadata"}

        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                missing_keys = required_keys - set(schema.keys())
                self.assertEqual(len(missing_keys), 0, f"{db_name} missing required keys: {missing_keys}")

    def test_all_schemas_have_metadata(self):
        """Every schema must have species and sample_regex metadata."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                metadata = schema.get("metadata", {})
                self.assertIn("species", metadata, f"{db_name} missing species metadata")
                self.assertIn("sample_regex", metadata, f"{db_name} missing sample_regex metadata")

    def test_all_schemas_have_3_columns(self):
        """Every database should have exactly 3 columns: data_probeset_id, data_signal, data_bot_id."""
        expected_columns = {"data_probeset_id", "data_signal", "data_bot_id"}

        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                column_names = {col["name"] for col in schema["columns"]}
                self.assertEqual(column_names, expected_columns, f"{db_name} has unexpected columns: {column_names}")

    def test_column_types_are_valid(self):
        """All column types must be one of: string, integer, float, text."""
        valid_types = {"string", "integer", "float", "text"}

        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            for column in schema["columns"]:
                with self.subTest(database=db_name, column=column["name"]):
                    col_type = column.get("type")
                    self.assertIn(col_type, valid_types, f"{db_name}.{column['name']} has invalid type: {col_type}")

    def test_string_columns_have_length(self):
        """String columns must have a length specified."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            for column in schema["columns"]:
                with self.subTest(database=db_name, column=column["name"]):
                    if column.get("type") == "string":
                        self.assertIn("length", column, f"{db_name}.{column['name']} is string but missing length")
                        self.assertIsInstance(column["length"], int, f"{db_name}.{column['name']} length must be int")
                        self.assertGreater(column["length"], 0, f"{db_name}.{column['name']} length must be > 0")

    def test_charset_is_valid(self):
        """Charset must be either latin1 or utf8mb4."""
        valid_charsets = {"latin1", "utf8mb4"}

        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                charset = schema.get("charset")
                self.assertIn(charset, valid_charsets, f"{db_name} has invalid charset: {charset}")

    def test_known_databases_have_correct_species(self):
        """Verify species metadata for known databases."""
        known_species = {
            "cannabis": "cannabis",
            "embryo": "arabidopsis",
            "wheat": "wheat",
            "maize_atlas_v5": "maize",
            "rice_root": "rice",
            "sorghum_atlas_w_BS_cells": "sorghum",
            "oat": "oat",
            "mouse_db": "mouse",
        }

        for db_name, expected_species in known_species.items():
            with self.subTest(database=db_name):
                schema = SIMPLE_EFP_DATABASE_SCHEMAS.get(db_name)
                self.assertIsNotNone(schema, f"{db_name} not found in schemas")
                actual_species = schema["metadata"]["species"]
                self.assertEqual(
                    actual_species,
                    expected_species,
                    f"{db_name} has species={actual_species}, expected {expected_species}",
                )

    def test_primary_keys_are_defined(self):
        """Each schema should have at least one primary key column."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            with self.subTest(database=db_name):
                pk_columns = [col["name"] for col in schema["columns"] if col.get("primary_key")]
                self.assertGreater(len(pk_columns), 0, f"{db_name} has no primary key columns")


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
            len(SIMPLE_EFP_SAMPLE_MODELS), 191, f"Expected 191 ORM models, found {len(SIMPLE_EFP_SAMPLE_MODELS)}"
        )

    def test_model_names_match_database_names(self):
        """ORM model keys should match schema keys."""
        schema_names = set(SIMPLE_EFP_DATABASE_SCHEMAS.keys())
        model_names = set(SIMPLE_EFP_SAMPLE_MODELS.keys())

        self.assertEqual(
            schema_names, model_names, f"Mismatch between schemas and models. Missing: {schema_names - model_names}"
        )

    def test_all_models_have_tablename(self):
        """Every model must have __tablename__ attribute."""
        for db_name, model in SIMPLE_EFP_SAMPLE_MODELS.items():
            with self.subTest(database=db_name):
                self.assertTrue(hasattr(model, "__tablename__"), f"{db_name} model missing __tablename__")
                self.assertEqual(model.__tablename__, "sample_data", f"{db_name} has wrong table name")

    def test_all_models_have_bind_key(self):
        """Every model must have __bind_key__ matching the database name."""
        for db_name, model in SIMPLE_EFP_SAMPLE_MODELS.items():
            with self.subTest(database=db_name):
                self.assertTrue(hasattr(model, "__bind_key__"), f"{db_name} model missing __bind_key__")
                self.assertEqual(model.__bind_key__, db_name, f"{db_name} has wrong bind_key")

    def test_models_have_correct_column_count(self):
        """Models should have the same number of columns as their schema."""
        for db_name, model in SIMPLE_EFP_SAMPLE_MODELS.items():
            with self.subTest(database=db_name):
                schema = SIMPLE_EFP_DATABASE_SCHEMAS[db_name]
                expected_cols = len(schema["columns"])

                # Count actual columns (excluding internal attributes)
                actual_cols = len(
                    [attr for attr in dir(model) if not attr.startswith("_") and hasattr(getattr(model, attr), "type")]
                )

                self.assertEqual(
                    actual_cols, expected_cols, f"{db_name} model has {actual_cols} columns, schema has {expected_cols}"
                )

    def test_known_models_have_expected_columns(self):
        """Verify specific models have the 3 expected columns."""
        expected_columns = ["data_probeset_id", "data_signal", "data_bot_id"]

        for db_name in ["cannabis", "oat", "mouse_db", "embryo", "wheat"]:
            with self.subTest(database=db_name):
                model = SIMPLE_EFP_SAMPLE_MODELS[db_name]
                for col_name in expected_columns:
                    self.assertTrue(hasattr(model, col_name), f"{db_name} model missing column: {col_name}")


class TestDatabaseCategoryDistribution(TestCase):
    """Test distribution of databases by species and type."""

    def test_species_distribution(self):
        """Verify we have databases for expected species."""
        species_counts = {}
        for schema in SIMPLE_EFP_DATABASE_SCHEMAS.values():
            species = schema["metadata"]["species"]
            species_counts[species] = species_counts.get(species, 0) + 1

        # Check we have major species covered
        major_species = ["arabidopsis", "maize", "wheat", "rice", "sorghum"]
        for species in major_species:
            with self.subTest(species=species):
                self.assertIn(species, species_counts, f"No databases found for {species}")
                self.assertGreater(species_counts[species], 0, f"Expected databases for {species}")

    def test_charset_distribution(self):
        """Verify charset distribution (should have both latin1 and utf8mb4)."""
        charset_counts = {}
        for schema in SIMPLE_EFP_DATABASE_SCHEMAS.values():
            charset = schema["charset"]
            charset_counts[charset] = charset_counts.get(charset, 0) + 1

        # Should have both charsets
        self.assertIn("latin1", charset_counts)
        self.assertIn("utf8mb4", charset_counts)

        # utf8mb4 should be more common (101 databases as of the current _UTF8MB4 set)
        self.assertGreater(
            charset_counts["utf8mb4"], 100, f"Expected ~101 utf8mb4 databases, found {charset_counts['utf8mb4']}"
        )


class TestVarcharLengths(TestCase):
    """Test that all string columns use VARCHAR(255)."""

    def test_all_string_columns_are_255(self):
        """All string columns should use a uniform length of 255."""
        for db_name, schema in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            for col in schema["columns"]:
                if col.get("type") == "string":
                    with self.subTest(database=db_name, column=col["name"]):
                        self.assertEqual(
                            col["length"], 255, f"{db_name}.{col['name']} length is {col['length']}, expected 255"
                        )
