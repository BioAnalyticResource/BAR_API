class BARUtilities:
    @staticmethod
    def error_exit(msg):
        result = {'success': False, 'error': msg}
        return result

    @staticmethod
    def success_exit(msg):
        result = {'success': True, 'data': msg}
        return result
