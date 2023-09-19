"""
Date: Aug 2023
Author: Vince L
Fastpheno endpoint for retrieving tree data
"""
from flask_restx import Namespace, Resource
from api import db
from api.models.fastpheno import Sites, Trees, Band, Height
from api.utils.bar_utils import BARUtils
from markupsafe import escape
import sys


fastpheno = Namespace("FastPheno", description="FastPheno API service", path="/fastpheno")


@fastpheno.route("/get_bands/<string:site>/<string:month>/<string:band>")
class FastPheno(Resource):
    @fastpheno.param("site", _in="path", default="pintendre")
    @fastpheno.param("month", _in="path", default="jan")
    @fastpheno.param("band", _in="path", default="band_1")
    def get(self, site, month, band):
        """This end point returns band values for a specific site AND month-date"""
        # Escape input data
        site = escape(site).capitalize()
        month = escape(month)
        band = escape(band)

        rows = db.session.execute(
            db.select(Sites, Trees, Height, Band)
            .select_from(Sites)
            .join(Trees, Trees.sites_pk == Sites.sites_pk) # don't need to use 2nd arg, for clarity... I set ORM rel
            .join(Height, Height.trees_pk == Trees.trees_pk)
            .join(Band, Band.trees_pk == Trees.trees_pk)
            .where(
                Sites.site_name == site, Band.month == month, Height.month == month, Band.band == band
            )
        ).all()
        res = [
            {
                "site_name" : s.site_name,
                "tree_id" : t.trees_pk,
                "longitude": t.longitude,
                "latitutde": t.latitude,
                "genotype_id": t.genotype_id,
                "tree_given_id": t.tree_given_id,
                "external_link": t.external_link,
                "band_value" : float(b.value),
                "tree_height_proxy" : float(h.tree_height_proxy),
                "ground_height_proxy" : float(h.ground_height_proxy),
                "band_month": b.month.name,
            }
            for s, t, h, b in rows
        ]
        if len(rows) == 0:
            return (
                BARUtils.error_exit("There are no data found for the given parameters"),
                400,
            )

        return BARUtils.success_exit(res)


@fastpheno.route("/get_trees/<string:genotype_id>")
class FastPhenoTrees(Resource):
    @fastpheno.param("genotype_id", _in="path", default="C")
    def get(self, genotype_id):
        """This end point returns trees for a given genotype_id across sites"""
        # Escape input data
        genotype_id = escape(genotype_id).capitalize()

        rows = db.session.execute(
            db.select(Sites, Trees)
            .select_from(Sites)
            .join(Trees, Trees.sites_pk == Sites.sites_pk)
            .where(
                Trees.genotype_id == genotype_id
            )
        ).all()
        res = [
            {
                "site_name" : s.site_name,
                "tree_id" : t.trees_pk,
                "longitude": t.longitude,
                "latitutde": t.latitude,
                "genotype_id": t.genotype_id,
                "tree_given_id": t.tree_given_id,
                "external_link": t.external_link,
            }
            for s, t in rows
        ]
        if len(rows) == 0:
            return (
                BARUtils.error_exit("There are no data found for the given parameters"),
                400,
            )

        return BARUtils.success_exit(res)
