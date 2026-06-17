"""
Date: Aug 2023
Author: Vince L
Fastpheno endpoint for retrieving tree data
"""

import re

from flask import request
from flask_restx import Namespace, Resource
from api import db
from api.models.fastpheno import Sites, Flights, Trees, TreesFlightsJoinTbl, Bands
from api.utils.bar_utils import BARUtils
from markupsafe import escape

fastpheno = Namespace("FastPheno", description="FastPheno API service", path="/fastpheno")


@fastpheno.route("/get_bands/<string:site>/<string:flight_id>/<string:band>")
class FastPheno(Resource):
    @fastpheno.param("site", _in="path", default="Pintendre")
    @fastpheno.param("flight_id", _in="path", default="14")
    @fastpheno.param("band", _in="path", default="398nm")
    def get(self, site, flight_id, band):
        """Returns all band values for a given site, flight ID, and band name"""
        site = str(escape(site)).capitalize()
        flight_id = str(escape(flight_id))
        band = str(escape(band))

        if not re.search(r"^[a-zA-Z]{1,15}$", site):
            return BARUtils.error_exit("Invalid site name"), 400

        if not BARUtils.is_integer(flight_id):
            return BARUtils.error_exit("Invalid flight ID"), 400

        if not re.search(r"^[a-zA-Z0-9_]{1,20}$", band):
            return BARUtils.error_exit("Invalid band"), 400

        rows = db.session.execute(
            db.select(Trees, TreesFlightsJoinTbl, Bands)
            .select_from(Bands)
            .join(
                TreesFlightsJoinTbl,
                (Bands.trees_pk == TreesFlightsJoinTbl.trees_pk) & (Bands.flights_pk == TreesFlightsJoinTbl.flights_pk),
            )
            .join(Trees, Bands.trees_pk == Trees.trees_pk)
            .join(Flights, Bands.flights_pk == Flights.flights_pk)
            .join(Sites, Flights.sites_pk == Sites.sites_pk)
            .where(Sites.site_name == site, Bands.flights_pk == int(flight_id), Bands.band == band)
        ).all()

        if len(rows) == 0:
            return BARUtils.error_exit("No data found for the given parameters"), 400

        res = [
            {
                "trees_pk": t.trees_pk,
                "seq_id": t.seq_id,
                "longitude": float(t.longitude),
                "latitude": float(t.latitude),
                "x_pos": t.x_pos,
                "y_pos": t.y_pos,
                "height_2022": t.height_2022,
                "block_num": t.block_num,
                "tree_site_id": t.tree_site_id,
                "confidence": float(tf.confidence) if tf.confidence is not None else None,
                "band_value": float(b.value),
            }
            for t, tf, b in rows
        ]

        return BARUtils.success_exit(res)


@fastpheno.route("/get_trees/<string:tree_site_id>")
class FastPhenoTrees(Resource):
    @fastpheno.param("tree_site_id", _in="path", default="619")
    @fastpheno.param("site", _in="query", required=False, default="Pintendre")
    def get(self, tree_site_id):
        """Returns trees for a given genotype. Accepts letter codes (e.g. 'c') or numeric
        genotype prefixes (e.g. '619' matches '619.03'). Optionally filter by site name."""
        tree_site_id = str(escape(tree_site_id))
        site = request.args.get("site")

        if not re.search(r"^[a-zA-Z0-9.]{1,15}$", tree_site_id):
            return BARUtils.error_exit("Invalid tree site ID"), 400

        if site is not None:
            site = str(escape(site)).capitalize()
            if not re.search(r"^[a-zA-Z]{1,15}$", site):
                return BARUtils.error_exit("Invalid site name"), 400

        query = (
            db.select(Sites, Trees)
            .select_from(Sites)
            .join(Trees, Trees.sites_pk == Sites.sites_pk)
            .where(db.or_(Trees.tree_site_id == tree_site_id, Trees.tree_site_id.like(f"{tree_site_id}.%")))
        )

        if site is not None:
            query = query.where(Sites.site_name == site)

        rows = db.session.execute(query).all()

        if len(rows) == 0:
            return BARUtils.error_exit("No data found for the given parameters"), 400

        res = [
            {
                "site_name": s.site_name,
                "trees_pk": t.trees_pk,
                "seq_id": t.seq_id,
                "longitude": float(t.longitude),
                "latitude": float(t.latitude),
                "tree_site_id": t.tree_site_id,
                "external_link": t.external_link,
            }
            for s, t in rows
        ]

        return BARUtils.success_exit(res)


@fastpheno.route("/timeseries/tree/<string:seq_id>/<string:band>")
class FastPhenoTimeSeries(Resource):
    @fastpheno.param("seq_id", _in="path", default="PIN_2547")
    @fastpheno.param("band", _in="path", default="398nm")
    def get(self, seq_id, band):
        """Returns all band values + confidence for a single tree across all flights, ordered by flight date, for time series."""
        seq_id = str(escape(seq_id)).upper()
        band = str(escape(band))

        if not re.search(r"^[A-Z]{2,5}_\d{1,6}$", seq_id):
            return BARUtils.error_exit("Invalid seq_id"), 400

        if not re.search(r"^[a-zA-Z0-9_]{1,20}$", band):
            return BARUtils.error_exit("Invalid band"), 400

        rows = db.session.execute(
            db.select(Flights, TreesFlightsJoinTbl, Bands)
            .select_from(Bands)
            .join(
                TreesFlightsJoinTbl,
                (Bands.trees_pk == TreesFlightsJoinTbl.trees_pk) & (Bands.flights_pk == TreesFlightsJoinTbl.flights_pk),
            )
            .join(Trees, Bands.trees_pk == Trees.trees_pk)
            .join(Flights, Bands.flights_pk == Flights.flights_pk)
            .where(Trees.seq_id == seq_id, Bands.band == band)
            .order_by(Flights.flight_date)
        ).all()

        if len(rows) == 0:
            return BARUtils.error_exit("No data found for the given parameters"), 400

        res = [
            {
                "flight_date": f.flight_date.isoformat(),
                "flights_pk": f.flights_pk,
                "confidence": float(tf.confidence) if tf.confidence is not None else None,
                "band_value": float(b.value),
            }
            for f, tf, b in rows
        ]

        return BARUtils.success_exit(res)


@fastpheno.route("/timeseries/genotype/<string:tree_site_id>/<string:band>/aggregate")
class FastPhenoGenotypeTimeSeries(Resource):
    @fastpheno.param("tree_site_id", _in="path", default="619")
    @fastpheno.param("band", _in="path", default="398nm")
    @fastpheno.param("site", _in="query", required=False, default="Pintendre")
    def get(self, tree_site_id, band):
        """Returns AVG and STDDEV of band values per flight date across all trees sharing a
        genotype (e.g. '619' matches all tree_site_id values starting with '619.'). Intended
        for genotype-level time series plotting. Optionally filter by site name."""
        tree_site_id = str(escape(tree_site_id))
        band = str(escape(band))
        site = request.args.get("site")

        if not re.search(r"^[a-zA-Z0-9.]{1,15}$", tree_site_id):
            return BARUtils.error_exit("Invalid tree site ID"), 400

        if not re.search(r"^[a-zA-Z0-9_]{1,20}$", band):
            return BARUtils.error_exit("Invalid band"), 400

        if site is not None:
            site = str(escape(site)).capitalize()
            if not re.search(r"^[a-zA-Z]{1,15}$", site):
                return BARUtils.error_exit("Invalid site name"), 400

        query = (
            db.select(
                Flights.flight_date,
                Flights.flights_pk,
                db.func.avg(Bands.value).label("avg_value"),
                db.func.std(Bands.value).label("std_value"),
                db.func.count(Bands.value).label("n_trees"),
            )
            .select_from(Bands)
            .join(
                TreesFlightsJoinTbl,
                (Bands.trees_pk == TreesFlightsJoinTbl.trees_pk) & (Bands.flights_pk == TreesFlightsJoinTbl.flights_pk),
            )
            .join(Trees, Bands.trees_pk == Trees.trees_pk)
            .join(Flights, Bands.flights_pk == Flights.flights_pk)
            .join(Sites, Flights.sites_pk == Sites.sites_pk)
            .where(
                db.or_(Trees.tree_site_id == tree_site_id, Trees.tree_site_id.like(f"{tree_site_id}.%")),
                Bands.band == band,
            )
            .group_by(Flights.flights_pk, Flights.flight_date)
            .order_by(Flights.flight_date)
        )

        if site is not None:
            query = query.where(Sites.site_name == site)

        rows = db.session.execute(query).all()

        if len(rows) == 0:
            return BARUtils.error_exit("No data found for the given parameters"), 400

        res = [
            {
                "flight_date": r.flight_date.isoformat(),
                "flights_pk": r.flights_pk,
                "avg_value": float(r.avg_value),
                "std_value": float(r.std_value) if r.std_value is not None else None,
                "n_trees": r.n_trees,
            }
            for r in rows
        ]

        return BARUtils.success_exit(res)


@fastpheno.route("/sites")
class FastPhenoSites(Resource):
    def get(self):
        """Returns all sites with coordinates, for initializing the map view."""
        rows = db.session.execute(db.select(Sites).order_by(Sites.site_name)).scalars().all()

        res = [
            {
                "sites_pk": s.sites_pk,
                "site_name": s.site_name,
                "lat": float(s.lat),
                "lng": float(s.lng),
                "site_desc": s.site_desc,
            }
            for s in rows
        ]

        return BARUtils.success_exit(res)


@fastpheno.route("/flights/<int:sites_pk>")
class FastPhenoFlights(Resource):
    @fastpheno.param("sites_pk", _in="path", default=1)
    def get(self, sites_pk):
        """Returns all flights for a given site, ordered by date, for populating the flight dropdown."""
        if not BARUtils.is_integer(str(sites_pk)):
            return BARUtils.error_exit("Invalid sites_pk"), 400

        rows = (
            db.session.execute(db.select(Flights).where(Flights.sites_pk == sites_pk).order_by(Flights.flight_date))
            .scalars()
            .all()
        )

        if len(rows) == 0:
            return BARUtils.error_exit("No flights found for the given site"), 400

        res = [
            {
                "flights_pk": f.flights_pk,
                "flight_date": f.flight_date.isoformat(),
                "pilot": f.pilot,
                "height": float(f.height) if f.height is not None else None,
                "speed": float(f.speed) if f.speed is not None else None,
            }
            for f in rows
        ]

        return BARUtils.success_exit(res)


@fastpheno.route("/bands/available/<int:flights_pk>")
class FastPhenoBandsAvailable(Resource):
    @fastpheno.param("flights_pk", _in="path", default=14)
    def get(self, flights_pk):
        """Returns all distinct band names available for a given flight."""
        if not BARUtils.is_integer(str(flights_pk)):
            return BARUtils.error_exit("Invalid flights_pk"), 400

        rows = (
            db.session.execute(
                db.select(Bands.band)
                .where(Bands.flights_pk == flights_pk)
                .distinct()
                .order_by(db.func.cast(db.func.regexp_replace(Bands.band, "[^0-9]", ""), db.Integer))
            )
            .scalars()
            .all()
        )

        if len(rows) == 0:
            return BARUtils.error_exit("No bands found for the given flight"), 400

        return BARUtils.success_exit(rows)
