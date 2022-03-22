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
    def validated_api_key(key):
        """Checks if a given API key is in the Users database
        :param key: The API key to be checked
        """
        tbl = SummarizationGeneExpressionUtils.get_table_object("users")

        # The key is an alphanumeric string
        key = str(key)
        if not key.isalnum():
            return None

        con = db.get_engine(bind="summarization")
        try:
            row = con.execute(
                db.select([tbl.c.uses_left]).where(tbl.c.api_key == key)
            ).first()
        except SQLAlchemyError:
            return None
        if row is None:
            return None
        else:
            if row.uses_left > 0:
                return key
            else:
                return None

    @staticmethod
    def decrement_uses(key):
        """Subtracts 1 from the uses_left column of the user whose key matches the given string
        :param key: The user's API key
        """

        # The key will be valid here.
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
