from api import app
from unittest import TestCase


# Each database, its rows per gene, and each fixture gene's stored Mean_CTRL row as the
# endpoint renders it. Several databases share a rows per gene, so the Mean_CTRL values
# are what catch a bind pointing at the wrong database.
PSEUDOBULK_DATABASES = [
    (
        "arabidopsis_flower_lee_pseudobulk",
        10,
        {
            "AT1G01010": ("0.0116959", "0.167702"),
            "AT1G01020": ("0.03165", "0.277587"),
            "AT1G01030": ("0.0373011", "0.306399"),
        },
    ),
    (
        "arabidopsis_root_shahan_pseudobulk",
        100,
        {
            "AT1G01010": ("0.157898", "0.422084"),
            "AT1G01020": ("0.0793918", "0.261753"),
            "AT1G01030": ("0.010148", "0.0959647"),
        },
    ),
    (
        "arabidopsis_rosette_21d_lee_pseudobulk",
        6,
        {
            "AT1G01010": ("0.00284308", "0.0456808"),
            "AT1G01020": ("0.0439676", "0.175693"),
            "AT1G01030": ("0.0212323", "0.126861"),
        },
    ),
    (
        "arabidopsis_rosette_30d_lee_pseudobulk",
        7,
        {
            "AT1G01010": ("0.00445705", "0.0556244"),
            "AT1G01020": ("0.0263362", "0.135038"),
            "AT1G01030": ("0.017151", "0.113482"),
        },
    ),
    (
        "arabidopsis_seed_0d_lee_pseudobulk",
        7,
        {
            "AT1G01010": ("0.00980994", "0.0833147"),
            "AT1G01020": ("0.031434", "0.148299"),
            "AT1G01030": ("0.0182901", "0.115757"),
        },
    ),
    (
        "arabidopsis_seed_martin_pseudobulk",
        35,
        {
            "AT1G01010": ("0.0171608", "0.176218"),
            "AT1G01020": ("0.0557825", "0.343745"),
            "AT1G01030": ("0.00160503", "0.0590966"),
        },
    ),
    (
        "arabidopsis_seedling_12d_lee_pseudobulk",
        6,
        {
            "AT1G01010": ("0.0295017", "0.263786"),
            "AT1G01020": ("0.0487004", "0.339183"),
            "AT1G01030": ("0.0595717", "0.380804"),
        },
    ),
    (
        "arabidopsis_seedling_3d_lee_pseudobulk",
        9,
        {
            "AT1G01010": ("0.00687618", "0.0697902"),
            "AT1G01020": ("0.0117318", "0.0909308"),
            "AT1G01030": ("0.00505709", "0.0598023"),
        },
    ),
    (
        "arabidopsis_seedling_6d_lee_pseudobulk",
        6,
        {
            "AT1G01010": ("0.0379364", "0.27957"),
            "AT1G01020": ("0.0864976", "0.41424"),
            "AT1G01030": ("0.0899645", "0.426446"),
        },
    ),
    (
        "arabidopsis_shoot_zhang_pseudobulk",
        10,
        {
            "AT1G01010": ("0.011989", "0.13384"),
            "AT1G01020": ("0.0622745", "0.262763"),
            "AT1G01030": ("0.038467", "0.251784"),
        },
    ),
    (
        "arabidopsis_silique_lee_pseudobulk",
        8,
        {
            "AT1G01010": ("0.00496354", "0.0593082"),
            "AT1G01020": ("0.0222446", "0.124802"),
            "AT1G01030": ("0.00131167", "0.0306192"),
        },
    ),
    (
        "arabidopsis_stem_lee_pseudobulk",
        9,
        {
            "AT1G01010": ("0.00751716", "0.131966"),
            "AT1G01020": ("0.0695734", "0.401791"),
            "AT1G01030": ("0.00053516", "0.0321555"),
        },
    ),
    (
        "rice_OW_pseudobulk",
        71,
        {
            "Os01g0100100": ("0.136496", "0.502172"),
            "Os01g0100200": ("0.00848389", "0.12733"),
            "Os01g0100400": ("0.0413686", "0.279097"),
        },
    ),
]

# Each database, its fixture cells, and the cells that carry an expression value for each
# fixture gene. The cells left out are the gaps: an absent key means zero expression.
UMAP_DATABASES = [
    (
        "arabidopsis_flower_lee_umap",
        [4, 45, 71, 157, 329, 359, 685, 817],
        {
            "AT1G01010": [157, 685, 817],
            "AT1G01020": [71, 329, 359],
            "AT1G01030": [4, 45],
        },
    ),
    (
        "arabidopsis_root_shahan_umap",
        [3, 16, 36, 44, 62, 82, 89, 159],
        {
            "AT1G01010": [3, 16, 44, 159],
            "AT1G01020": [36, 62, 82, 89],
            "AT1G01030": [89, 159],
        },
    ),
    (
        "arabidopsis_rosette_21d_lee_umap",
        [18, 19, 31, 56, 71, 84, 169, 443],
        {
            "AT1G01010": [71, 169, 443],
            "AT1G01020": [18, 31, 56],
            "AT1G01030": [19, 31, 84],
        },
    ),
    (
        "arabidopsis_rosette_30d_lee_umap",
        [3, 52, 76, 77, 114, 116, 775, 783],
        {
            "AT1G01010": [52, 775, 783],
            "AT1G01020": [76, 77, 116],
            "AT1G01030": [3, 114],
        },
    ),
    (
        "arabidopsis_seed_0d_lee_umap",
        [0, 3, 21, 31, 56, 125, 154, 208],
        {
            "AT1G01010": [125, 154, 208],
            "AT1G01020": [21, 31, 56],
            "AT1G01030": [0, 3],
        },
    ),
    (
        "arabidopsis_seed_martin_umap",
        [10, 143, 145, 155, 171, 233, 1593, 1723],
        {
            "AT1G01010": [10, 143, 171],
            "AT1G01020": [145, 155, 233],
            "AT1G01030": [1593, 1723],
        },
    ),
    (
        "arabidopsis_seedling_12d_lee_umap",
        [19, 98, 141, 157, 237, 241, 489, 557],
        {
            "AT1G01010": [19, 489, 557],
            "AT1G01020": [98, 157, 237],
            "AT1G01030": [141, 241],
        },
    ),
    (
        "arabidopsis_seedling_3d_lee_umap",
        [1, 32, 63, 92, 112, 166, 354, 381],
        {
            "AT1G01010": [63, 92, 112],
            "AT1G01020": [1, 166, 354],
            "AT1G01030": [32, 381],
        },
    ),
    (
        "arabidopsis_seedling_6d_lee_umap",
        [1, 14, 19, 50, 106, 118, 119, 269],
        {
            "AT1G01010": [106, 118, 269],
            "AT1G01020": [1, 50, 119],
            "AT1G01030": [14, 19],
        },
    ),
    (
        "arabidopsis_shoot_zhang_umap",
        [5, 8, 13, 18, 23, 30, 36, 37],
        {
            "AT1G01010": [23, 30, 36],
            "AT1G01020": [5, 8, 18, 30],
            "AT1G01030": [13, 37],
        },
    ),
    (
        "arabidopsis_silique_lee_umap",
        [28, 34, 104, 120, 278, 370, 799, 987],
        {
            "AT1G01010": [28, 278, 370],
            "AT1G01020": [34, 104, 120],
            "AT1G01030": [799, 987],
        },
    ),
    (
        "arabidopsis_stem_lee_umap",
        [100, 144, 162, 522, 598, 814, 9526, 9544],
        {
            "AT1G01010": [522, 598, 814],
            "AT1G01020": [100, 144, 162],
            "AT1G01030": [9526, 9544],
        },
    ),
    (
        "rice_OW_umap",
        [28, 36, 38, 40, 82, 123, 180, 279],
        {
            "Os01g0100100": [36, 38, 40],
            "Os01g0100200": [82, 180, 279],
            "Os01g0100400": [28, 123],
        },
    ),
]


class TestIntegrations(TestCase):
    def setUp(self):
        self.app_client = app.test_client()

    def test_get_superviewer_pseudobulk_expression(self):
        """This tests the pseudobulk expression data returned for every SUPeR Viewer database
        :return:
        """
        for database, rows_per_gene, mean_ctrl in PSEUDOBULK_DATABASES:
            for gene, (value, value_std) in mean_ctrl.items():
                with self.subTest(database=database, gene=gene):
                    response = self.app_client.get("/gene_expression/expression/{}/{}".format(database, gene))
                    self.assertEqual(response.status_code, 200)
                    data = response.json["data"]

                    # Every gene carries all of its database's rows, Mean_CTRL included
                    self.assertEqual(data["record_count"], rows_per_gene)
                    self.assertEqual(len(data["data"]), rows_per_gene)
                    for row in data["data"]:
                        self.assertEqual(set(row), {"name", "value", "value_std"})

                    # Mean_CTRL comes back inline, exactly once, with its stored values
                    controls = [row for row in data["data"] if row["name"] == "Mean_CTRL"]
                    self.assertEqual(len(controls), 1)
                    self.assertEqual(controls[0]["value"], value)
                    self.assertEqual(controls[0]["value_std"], value_std)

    def test_get_superviewer_umap_coordinates(self):
        """This tests the UMAP coordinates returned for every SUPeR Viewer database
        :return:
        """
        for database, cells, _expression_cells in UMAP_DATABASES:
            with self.subTest(database=database):
                response = self.app_client.get("/umap_gene_expression/{}".format(database))
                self.assertEqual(response.status_code, 200)
                self.assertEqual(sorted(int(cell) for cell in response.json["data"]), cells)

    def test_get_superviewer_umap_expression(self):
        """This tests that UMAP expression stays sparse: gap cells have no key
        :return:
        """
        for database, _cells, expression_cells in UMAP_DATABASES:
            for gene, cells in expression_cells.items():
                with self.subTest(database=database, gene=gene):
                    response = self.app_client.get("/umap_gene_expression/{}/{}".format(database, gene))
                    self.assertEqual(response.status_code, 200)
                    self.assertEqual(sorted(int(cell) for cell in response.json["data"]), cells)
