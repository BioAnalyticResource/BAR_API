import re
from api.utils.bar_utils import BARUtils


class eFPUtils:
    @staticmethod
    def is_efp_view_name(efp_view):
        """This function is used for validated eFP View names for eFP service
        :param efp_view: string view name
        :return: True if valid
        """
        if efp_view and re.search(r"^[a-z1-9_]{1,20}$", efp_view, re.I):
            return True
        else:
            return False

    @staticmethod
    def is_efp_mode(efp_mode):
        """This function checks if the eFP mode is valid
        :param efp_mode: string eFP Mode
        :return: True or False
        """
        # These are case-sensitive
        valid_modes = ["Absolute", "Relative", "Compare"]
        if efp_mode in valid_modes:
            return True
        else:
            return False

    @staticmethod
    def is_efp_input_valid(efp, view, mode, gene_1, gene_2=None):
        """Test if eFP input is valid
        :return: List with boolean and string
        """
        species = ["efp_arabidopsis", "efp_cannabis"]

        # Validate values
        if efp not in species:
            return False, "Invalid eFP."

        # Validate view
        if not eFPUtils.is_efp_view_name(view):
            return False, "Invalid eFP View name."

        # Validate mode
        if not eFPUtils.is_efp_mode(mode):
            return False, "Invalid eFP mode."

        # Maybe this part could be imported
        if efp == "efp_arabidopsis":
            # Validate gene ids
            if not BARUtils.is_arabidopsis_gene_valid(gene_1):
                return False, "Gene 1 is invalid."

            if mode == "Compare":
                if not BARUtils.is_arabidopsis_gene_valid(gene_2):
                    return False, "Gene 2 is invalid."

        if efp == "efp_cannabis":
            # Validate gene ids
            if not BARUtils.is_cannabis_gene_valid(gene_1):
                return False, "Gene 1 is invalid."

            if mode == "Compare":
                if not BARUtils.is_cannabis_gene_valid(gene_2):
                    return False, "Gene 2 is invalid."

        # Assuming all check have passed
        return True, None
