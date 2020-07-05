from api import r
from redis import exceptions


class BARUtilities:
    @staticmethod
    def error_exit(msg):
        """
        Exit if failed
        :param msg: message to pass on failure
        :return:
        """
        result = {'wasSuccessful': False, 'error': msg}
        return result

    @staticmethod
    def success_exit(msg):
        """
        Output if success
        :param msg: the actual data the needs to be output
        :return:
        """
        result = {'wasSuccessful': True, 'data': msg}
        return result

    @staticmethod
    def is_redis_available():
        """
        Redis is optional. This function check if it is available.
        :return: True if redis is found.
        """
        found = True
        try:
            r.ping()
        except exceptions.ConnectionError:
            found = False
        return found
