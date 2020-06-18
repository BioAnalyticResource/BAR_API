class BARUtilities:
    @staticmethod
    def error_exit(msg):
        result = {'status': 'fail', 'error': msg}
        return result

    @staticmethod
    def success_exit(msg):
        result = {'status': 'success', 'result': msg}
        return result
