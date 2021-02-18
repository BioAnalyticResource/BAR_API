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
    def is_poplar_gene_valid(gene):
        """This function verifies if Poplar v3 gene is valid
        :param gene:
        :return: True if valid
        """
        if re.search(r"^POTRI\.\d{3}g\d{6}.?\d?$", gene, re.I):
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

    @staticmethod
    def format_poplar(poplar_gene):
        """Format Poplar gene ID to be Potri.016G107900, i.e. capitalized P and G
        :param poplar_gene: gene id
        :return: String
        """
        return poplar_gene.translate(str.maketrans('pOTRIg', 'PotriG'))
