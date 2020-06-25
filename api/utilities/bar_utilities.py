from api.base import r
from redis import exceptions


class BARUtilities:
    @staticmethod
    def error_exit(msg):
        result = {'success': False, 'error': msg}
        return result

    @staticmethod
    def success_exit(msg):
        result = {'success': True, 'data': msg}
        return result

    @staticmethod
    def is_redis_available():
        try:
            r.ping()
            return True
        except exceptions.ConnectionError:
            return False
