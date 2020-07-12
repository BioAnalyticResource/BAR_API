from api import r
from redis import exceptions
import re


class BARUtils:
    @staticmethod
    def error_exit(msg):
        """Exit if failed
        :param msg: message to pass on failure
        :return:
        """
        result = {'wasSuccessful': False, 'error': msg}
        return result

    @staticmethod
    def success_exit(msg):
        """Output if success
        :param msg: the actual data the needs to be output
        :return:
        """
        result = {'wasSuccessful': True, 'data': msg}
        return result

    @staticmethod
    def is_redis_available():
        """Redis is optional. This function check if it is available.
        :return: True if redis is found.
        """
        found = True
        try:
            r.ping()
        except exceptions.ConnectionError:
            found = False
        return found

    @staticmethod
    def is_arabidopsis_gene_valid(gene):
        """This function verifies if Arabidopsis gene is valid
        :param gene:
        :return:
        """
        if re.search(r"^At[12345cm]g\d{5}.?\d?$", gene, re.I):
            return True
        else:
            return False

    @staticmethod
    def is_integer(data):
        """Check if the input is at max ten figure number.
        :param data: int number
        :return: True if a number
        """
        if re.search(r"^\d{1,10}$", data):
            return True
        else:
            return False
