"""
Reena Obmina | BCB330 Project 2025-2026 | University of Toronto

Dynamic SQLAlchemy model generation for all eFP databases.

At import time, one ORM model class is generated per database entry in
SIMPLE_EFP_DATABASE_SCHEMAS and stored in SIMPLE_EFP_SAMPLE_MODELS.
This replaces ~1,984 lines of hand-written boilerplate with a single registry.
"""

from __future__ import annotations

from typing import Dict

from sqlalchemy import Float, Integer, String, Text
from sqlalchemy.dialects.mysql import INTEGER

from api import db
from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS


def _to_sqla_type(column_spec):
    """
    Map a column specification dictionary to a SQLAlchemy column type.

    Converts the simple type descriptors used in schema definitions to the
    appropriate SQLAlchemy type objects for ORM model generation.

    :param column_spec: Column specification with 'type', 'length', and 'unsigned' keys
    :type column_spec: Dict[str, Any]
    :return: SQLAlchemy column type (String, Integer, Float, or Text)
    :rtype: sqlalchemy.types.TypeEngine
    :raises ValueError: If column type is not one of: string, integer, float, text

    Example::

        col_spec = {"type": "string", "length": 24}
        sqla_type = _to_sqla_type(col_spec)  # Returns String(24)
    """
    col_type = column_spec.get("type")
    if col_type == "string":
        return String(column_spec["length"])
    if col_type == "integer":
        if column_spec.get("unsigned"):
            return INTEGER(unsigned=True)
        return Integer
    if col_type == "float":
        return Float
    if col_type == "text":
        return Text
    raise ValueError(f"Unsupported column type: {col_type}")


def _generate_model(bind_key: str, spec) -> db.Model:
    """
    Build a concrete SQLAlchemy model class for the given schema specification.

    Dynamically creates an ORM model with the specified table name, bind key,
    and columns based on the schema definition. The generated model class can
    be used like any Flask-SQLAlchemy model.

    :param bind_key: Database bind key (e.g., 'cannabis', 'embryo')
    :type bind_key: str
    :param spec: Database schema specification from SIMPLE_EFP_DATABASE_SCHEMAS
    :type spec: Dict[str, Any]
    :return: Dynamically generated SQLAlchemy model class
    :rtype: db.Model

    Example::

        schema = SIMPLE_EFP_DATABASE_SCHEMAS['cannabis']
        CannabisModel = _generate_model('cannabis', schema)
        # Returns class: CannabisSampleData(db.Model)
    """
    attrs = {"__bind_key__": bind_key, "__tablename__": spec["table_name"]}

    for column in spec["columns"]:
        kwargs = {"nullable": column.get("nullable", True)}
        if column.get("primary_key"):
            kwargs["primary_key"] = True
        attrs[column["name"]] = db.mapped_column(_to_sqla_type(column), **kwargs)

    class_name = "".join([part.capitalize() for part in bind_key.split("_")]) + "SampleData"
    return type(class_name, (db.Model,), attrs)


SIMPLE_EFP_SAMPLE_MODELS: Dict[str, db.Model] = {
    db_name: _generate_model(db_name, spec) for db_name, spec in SIMPLE_EFP_DATABASE_SCHEMAS.items()
}

__all__ = ["SIMPLE_EFP_SAMPLE_MODELS"]
