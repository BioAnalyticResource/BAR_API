import re
from api import summarization_db as db
from sqlalchemy.exc import SQLAlchemyError


class SummarizationGeneExpressionUtils:
    @staticmethod
    def get_table_object(table_name):
        metadata = db.MetaData()
        table_object = db.Table(
            table_name,
            metadata,
            autoload=True,
            autoload_with=db.get_engine(bind="summarization"),
        )
        return table_object

    @staticmethod
    def is_valid(string):
        """Checks if a given string only contains alphanumeric characters
        :param string: The string to be checked
        """
        if re.search(r"([^_0-9A-Za-z])+", string):
            return False
        else:
            return True

    @staticmethod
    def validate_api_key(key):
        """Checks if a given API key is in the Users database
        :param key: The API key to be checked
        """
        tbl = SummarizationGeneExpressionUtils.get_table_object("users")
        con = db.get_engine(bind="summarization")
        try:
            row = con.execute(
                db.select([tbl.c.uses_left]).where(tbl.c.api_key == key)
            ).first()
        except SQLAlchemyError as e:
            error = str(e.__dict__["orig"])
            return error
        if row is None:
            return False
        else:
            if row.uses_left > 0:
                return True
            else:
                return False

    @staticmethod
    def decrement_uses(key):
        """Subtracts 1 from the uses_left column of the user whose key matches the given string
        :param key: The user's API key
        """
        if SummarizationGeneExpressionUtils.validate_api_key(key):
            tbl = SummarizationGeneExpressionUtils.get_table_object("users")
            con = db.get_engine(bind="summarization")
            try:
                con.execute(
                    db.update(tbl)
                    .where(tbl.c.api_key == key)
                    .values(uses_left=(tbl.c.uses_left - 1))
                )
                db.session.commit()
            except SQLAlchemyError as e:
                error = str(e.__dict__["orig"])
                return error
            return True
        else:
            return False
