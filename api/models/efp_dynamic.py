"""Every eFP database exposes the same sample_data table, so instead of hand-writing
~190 near-identical model files we generate one model class per database here."""

from api import db
from api.utils.bar_utils import load_combined_master


def _sample_data_model(database):
    class_name = "".join(part.capitalize() for part in database.split("_")) + "SampleData"
    return type(
        class_name,
        (db.Model,),
        {
            "__bind_key__": database,
            "__tablename__": "sample_data",
            "data_probeset_id": db.mapped_column(db.String(255), primary_key=True),
            "data_bot_id": db.mapped_column(db.String(255), primary_key=True),
            "data_signal": db.mapped_column(db.Float, primary_key=True),
        },
    )


SAMPLE_DATA_MODELS = {database: _sample_data_model(database) for database in load_combined_master()["databases"]}
