"""
Date: Nov 2021
Author: Vincent Lau
Interactions (Protein-Protein, Protein-DNA, etc.) endpoint
"""

from flask_restx import Namespace, Resource, fields
from flask import request, jsonify
from markupsafe import escape
from api.utils.bar_utils import BARUtils
from api.utils.mfinder_utils import MfinderUtils
from marshmallow import Schema, ValidationError, fields as marshmallow_fields
from api import db
from api.models.rice_interactions import Interactions as RiceInteractions
from sqlalchemy import or_
from api.models.interactions_vincent_v2 import Interactions as PostInteractions
from api.models.interactions_vincent_v2 import InteractionsSourceMiJoin as PostInteractionsSourceMiJoin
from api.models.interactions_vincent_v2 import TagLookupTable as TagLookupTable
from api.models.interactions_vincent_v2 import ExternalSource as ExternalSource
from api.models.interactions_vincent_v2 import SourceTagJoinTable as SourceTagJoinTable

itrns = Namespace(
    "Interactions",
    description="Interactions (protein-protein, protein-DNA, etc) endpoint",
    path="/interactions",
)

itrns_post_ex = itrns.model(
    "ItrnsRiceGenes",
    {
        "species": fields.String(required=True, example="rice"),
        "genes": fields.List(
            required=True,
            example=["LOC_Os01g01080", "LOC_Os01g73310"],
            cls_or_instance=fields.String,
        ),
    },
)

post_int_data = itrns.model(
    "MFinderData",
    {
        "data": fields.List(
            required=True,
            example=[["AT5G67420", "AT1G12110"], ["AT5G67420", "AT1G08090"]],
            cls_or_instance=fields.List(fields.String),
        ),
    },
)

single_itrns = itrns.model(
    "SingleItrn",
    {
        "interaction_id": fields.Integer(required=True, example=70),
    },
)


itrns_by_ref = itrns.model(
    "ItrnsByRef",
    {
        "paper_id": fields.Integer(required=True, example=15),
    },
)


search_by_tag = itrns.model(
    "searchByTag",
    {
        "tag": fields.String(required=True, example="APETALA2"),
    },
)


get_paper = itrns.model(
    "getPaper",
    {
        "number": fields.Integer(required=True, example=14),
    },
)


get_paper_by_agi = itrns.model(
    "getPaperByAGI",
    {
        "stringAGI": fields.String(required=True, example="AT2G30530"),
    },
)


get_paper_by_agi_pair = itrns.model(
    "getPaperByAGIPair",
    {
        "AGI_1": fields.String(required=True, example="AT2G30530"),
        "AGI_2": fields.String(required=True, example="AT4G33430"),
    },
)


class GeneIntrnsSchema(Schema):
    species = marshmallow_fields.String(required=True)
    genes = marshmallow_fields.List(cls_or_instance=marshmallow_fields.String)


class MFinderDataSchema(Schema):
    data = marshmallow_fields.List(marshmallow_fields.List(marshmallow_fields.String()))


class GetSingleItrnSchema(Schema):
    interaction_id = marshmallow_fields.Integer(required=True)


class GetIntrnsByRefSchema(Schema):
    paper_id = marshmallow_fields.Integer(required=True)


class SearchByTagSchema(Schema):
    tag = marshmallow_fields.String(required=True)


class GetPaperSchema(Schema):
    number = marshmallow_fields.Integer(required=True)


class GetPaperByAGISchema(Schema):
    stringAGI = marshmallow_fields.String(required=True)


class GetPaperByAGIPairSchema(Schema):
    AGI_1 = marshmallow_fields.String(required=True)
    AGI_2 = marshmallow_fields.String(required=True)


@itrns.route("/<species>/<query_gene>")
class Interactions(Resource):
    @itrns.param("species", _in="path", default="rice")
    @itrns.param("query_gene", _in="path", default="LOC_Os01g52560")
    def get(self, species="", query_gene=""):
        """
        Returns the protein-protein interactions for a particular query gene
        Supported species: 'rice'
        """

        species = escape(species.lower())
        query_gene = escape(query_gene)

        if species == "rice" and BARUtils.is_rice_gene_valid(query_gene):
            rows = (
                db.session.execute(
                    db.select(RiceInteractions).where(
                        or_(
                            RiceInteractions.Protein1 == query_gene,
                            RiceInteractions.Protein2 == query_gene,
                        ),
                    )
                )
                .scalars()
                .all()
            )

            if len(rows) == 0:
                return (
                    BARUtils.error_exit("There are no data found for the given gene"),
                    400,
                )
            else:
                res = [
                    {
                        "protein_1": i.Protein1,
                        "protein_2": i.Protein2,
                        "total_hits": i.Total_hits,
                        "Num_species": i.Num_species,
                        "Quality": i.Quality,
                        "pcc": i.Pcc,
                    }
                    for i in rows
                ]
                return BARUtils.success_exit(res)
        else:
            return BARUtils.error_exit("Invalid species or gene ID"), 400


@itrns.route("/")
class InteractionsPost(Resource):
    @itrns.expect(itrns_post_ex)
    def post(self):
        """
        Returns the protein-protein interactions for a particular query genes
        Supported species: 'rice'
        """

        json_data = request.get_json()

        try:
            json_data = GeneIntrnsSchema().load(json_data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        species = json_data["species"].lower()
        genes = json_data["genes"]

        if species == "rice":
            for gene in genes:
                if not BARUtils.is_rice_gene_valid(gene):
                    return BARUtils.error_exit("Invalid gene id"), 400

            rows = (
                db.session.execute(
                    db.select(RiceInteractions).where(
                        or_(
                            RiceInteractions.Protein1.in_(genes),
                            RiceInteractions.Protein2.in_(genes),
                        ),
                    )
                )
                .scalars()
                .all()
            )

        else:
            return BARUtils.error_exit("Invalid species"), 400

        if len(rows) > 0:
            res = [
                {
                    "protein_1": i.Protein1,
                    "protein_2": i.Protein2,
                    "total_hits": i.Total_hits,
                    "Num_species": i.Num_species,
                    "Quality": i.Quality,
                    "pcc": i.Pcc,
                }
                for i in rows
            ]
            return BARUtils.success_exit(res)
        else:
            return BARUtils.error_exit("No data for the given species/genes"), 400


@itrns.route("/mfinder")
class MFinder(Resource):
    @itrns.expect(post_int_data)
    def post(self):
        """This endpoint was originally written by Vincent Lau to return mFinder
        results to AGENT in his express node.JS app. However Tianhui Zhao refactored
        to the BAR_API
        """
        data = request.get_json()
        # Validate json
        try:
            data = MFinderDataSchema().load(data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        filtered_valid_arr = MfinderUtils.input_validation(data["data"])
        if isinstance(filtered_valid_arr, str):
            return BARUtils.error_exit(filtered_valid_arr), 400
        settings = MfinderUtils.settings_validation(data.get("options", {}))
        ret_json = MfinderUtils.create_files_and_mfinder(filtered_valid_arr, settings)
        return jsonify(MfinderUtils.beautify_results(ret_json))


@itrns.route("/single_interaction/<interaction_id>")
class SingleInteraction(Resource):
    @itrns.param("interaction_id", _in="path", default=70)
    def get(self, interaction_id=""):
        """
        Returns a single interaction record by its interaction ID.
        """
        result = []

        try:
            number = int(interaction_id)
        except ValueError:
            return BARUtils.error_exit("ID given was not a number!"), 400

        try:
            interactions_database = PostInteractions
            query = db.select(interactions_database).where(interactions_database.interaction_id == number)
            rows = db.session.execute(query).scalars().all()
            for row in rows:
                result.append(
                    {
                        "interaction_id": row.interaction_id,
                        "pearson_correlation_coeff": row.pearson_correlation_coeff,
                        "entity_1": row.entity_1,
                        "entity_2": row.entity_2,
                        "interaction_type_id": row.interaction_type_id,
                    }
                )

            if len(result) == 0:
                return BARUtils.error_exit("Invalid interaction ID"), 400
            return BARUtils.success_exit(result)
        except ValidationError as e:
            return BARUtils.error_exit(e.messages), 400


@itrns.route("/interactions_by_ref/<paper_id>")
class InteractionsByRef(Resource):
    @itrns.param("paper_id", _in="path", default=15)
    def get(self, paper_id=""):
        """
        Returns all interactions associated with a given source ID.
        """
        result = []

        # Ensure paper_id is an integer
        try:
            paper_id = int(paper_id)
        except ValueError:
            return BARUtils.error_exit("ID given was not a number!"), 400

        try:
            interactions_database = PostInteractions
            itnsjoin_database = PostInteractionsSourceMiJoin
            query = db.select(
                interactions_database,
                itnsjoin_database
                ).select_from(interactions_database).join(
                        itnsjoin_database,
                        interactions_database.interaction_id == itnsjoin_database.interaction_id
                    ).where(itnsjoin_database.source_id == paper_id)
            rows = db.session.execute(query).all()
            for i, m in rows:
                result.append(
                    {
                        "interaction_id": i.interaction_id,
                        "pearson_correlation_coeff": i.pearson_correlation_coeff,
                        "entity_1": i.entity_1,
                        "entity_2": i.entity_2,
                        "interaction_type_id": i.interaction_type_id,
                        "mode_of_action": m.mode_of_action,
                        "mi_detection_method": m.mi_detection_method,
                        "mi_detection_type": m.mi_detection_type,
                    }
                )

            if len(result) == 0:
                return BARUtils.error_exit("Invalid paper ID"), 400
            return BARUtils.success_exit(result)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400


@itrns.route("/all_tags")
class AllTags(Resource):
    def get(self):
        """
        Returns all tags in the format 'tag_name:tag_group' as a single pipe-separated string.
        """
        grouped_result = []

        try:
            tag_database = TagLookupTable
            query = db.select(tag_database.tag_name, tag_database.tag_group)
            rows = db.session.execute(query).all()

            for tag_name, tag_group in rows:
                grouped_result.append(f"{tag_name}:{tag_group}")
            grouped_result = "|".join(grouped_result)
            result = {"tag": grouped_result}
            return BARUtils.success_exit(result)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400


@itrns.route("/search_by_tag/<tag>")
class SearchByTag(Resource):
    @itrns.param("tag", _in="path", default="CBF")
    def get(self, tag=""):
        """
        Returns a list of sources that are associated with the given tag.
        """
        result = []

        try:
            ext_src_database = ExternalSource
            src_tag_join_database = SourceTagJoinTable
            tag_lkup_database = TagLookupTable

            # Step 1: Get source_ids that contain the searched tag

            matching_source_ids = []
            query_source = db.select(src_tag_join_database.source_id).where(
                src_tag_join_database.tag_name == tag
            )
            rows_source = db.session.execute(query_source).all()
            matching_source_ids = [row[0] for row in rows_source]

            if not matching_source_ids:
                return BARUtils.error_exit("Invalid tag name"), 400

            # Step 2: Get all tags for those sources
            query = (
                db.select(
                    ext_src_database,
                    src_tag_join_database.tag_name,
                    tag_lkup_database.tag_group
                )
                .join(src_tag_join_database, ext_src_database.source_id == src_tag_join_database.source_id)
                .join(tag_lkup_database, src_tag_join_database.tag_name == tag_lkup_database.tag_name)
                .where(ext_src_database.source_id.in_(matching_source_ids))  # Keep all tags for matched sources
            )
            rows = db.session.execute(query).all()

            src_tag_match = {}
            for ex, name, group in rows:
                if ex.source_id not in src_tag_match:
                    src_tag_match[ex.source_id] = [f"{name}:{group}"]
                else:
                    src_tag_match[ex.source_id].append(f"{name}:{group}")

            one_source = {}

            for ex, name, group in rows:
                source_id = ex.source_id
                if source_id not in one_source:
                    one_source[source_id] = {
                        "source_id": source_id,
                        "source_name": ex.source_name,
                        "comments": ex.comments,
                        "date_uploaded": ex.date_uploaded.isoformat() if ex.date_uploaded else None,
                        "url": ex.url,
                        "image_url": ex.image_url,
                        "grn_title": ex.grn_title,
                        "cyjs_layout": ex.cyjs_layout,
                        "tag": "|".join(src_tag_match[ex.source_id])
                    }
                    result.append(one_source[source_id])

            return BARUtils.success_exit(result)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400


@itrns.route("/get_all_papers")
class GetAllPapers(Resource):
    def get(self):
        """
        Returns a list of all papers stored in the database.
        """
        result = []

        try:
            ext_src_database = ExternalSource
            query = db.select(ext_src_database)
            rows = db.session.execute(query).scalars().all()

            for row in rows:
                result.append(
                    {
                        "source_id": row.source_id,
                        "source_name": row.source_name,
                        "comments": row.comments,
                        "date_uploaded": row.date_uploaded.strftime("%Y/%m/%d") if row.date_uploaded else None,
                        "url": row.url,
                        "image_url": row.image_url,
                        "grn_title": row.grn_title,
                        "cyjs_layout": row.cyjs_layout,
                    }
                )
            return BARUtils.success_exit(result)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400


@itrns.route("/get_paper/<number>")
class GetPaper(Resource):
    @itrns.param("number", _in="path", default=14)
    def get(self, number=""):
        """
        Returns information for a single external source by its source ID.
        """
        result = []

        try:
            number = int(number)
        except ValueError:
            return BARUtils.error_exit("Input number is not an integer!"), 400

        try:
            ext_src_database = ExternalSource
            query = db.select(ext_src_database).where(ext_src_database.source_id == number)
            rows = db.session.execute(query).scalars().all()

            for row in rows:
                result.append(
                    {
                        "source_id": row.source_id,
                        "source_name": row.source_name,
                        "comments": row.comments,
                        "date_uploaded": row.date_uploaded.strftime("%Y/%m/%d") if row.date_uploaded else None,
                        "url": row.url,
                        "image_url": row.image_url,
                        "grn_title": row.grn_title,
                        "cyjs_layout": row.cyjs_layout
                    }
                )

            if len(result) == 0:
                return BARUtils.error_exit("Invalid source ID"), 400
            return BARUtils.success_exit(result)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400


@itrns.route("/get_paper_by_agi/<stringAGI>")
class GetPaperByAGI(Resource):
    @itrns.param("stringAGI", _in="path", default="AT2G30530")
    def get(self, stringAGI=""):
        """
        Returns papers where the AGI appears in either `entity_1` or `entity_2`
        """

        try:
            es = ExternalSource
            i_s_mi_join_table = PostInteractionsSourceMiJoin
            i = PostInteractions
            stjt = SourceTagJoinTable
            tlt = TagLookupTable

            # Step 1: Query Data (Including Tags)
            query = (
                db.select(
                    es.source_id,
                    es.grn_title,
                    es.image_url,
                    es.source_name,
                    es.comments,
                    es.cyjs_layout,
                    stjt.tag_name,
                    tlt.tag_group
                )
                .join(i_s_mi_join_table, i_s_mi_join_table.source_id == es.source_id)
                .join(i, i.interaction_id == i_s_mi_join_table.interaction_id)
                .join(stjt, es.source_id == stjt.source_id)
                .join(tlt, stjt.tag_name == tlt.tag_name)
                .filter(
                    (i.entity_1 == stringAGI) | (i.entity_2 == stringAGI)  # Either entity 1 or entity 2 is stringAGI
                )
                .filter(es.grn_title.isnot(None))
            )
            rows = db.session.execute(query).all()

            # Step 2: Group Results Manually
            result_dict = {}

            for row in rows:
                source_id = row.source_id

                if source_id not in result_dict:
                    result_dict[source_id] = {
                        "source_id": row.source_id,
                        "grn_title": row.grn_title,
                        "image_url": row.image_url,
                        "source_name": row.source_name,
                        "comments": row.comments,
                        "cyjs_layout": row.cyjs_layout,
                        "tags": []
                    }

                tag_entry = f"{row.tag_name}:{row.tag_group}"
                if tag_entry not in result_dict[source_id]["tags"]:  # DISTINCT
                    result_dict[source_id]["tags"].append(tag_entry)

            result = [
                {
                    **data,
                    "tags": "|".join(data["tags"])  # overwrites tags
                }
                for data in result_dict.values()
            ]

            if len(result) == 0:
                return BARUtils.error_exit("Invalid AGI"), 400
            return BARUtils.success_exit(result)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400


@itrns.route("/get_paper_by_agi_pair/<AGI_1>/<AGI_2>")
class GetPaperByAGIPair(Resource):
    @itrns.param("AGI_1", _in="path", default="AT2G30530")
    @itrns.param("AGI_2", _in="path", default="AT4G33430")
    def get(self, AGI_1="", AGI_2=""):
        """
        Returns papers where either AGI appears in `entity_1` or `entity_2`
        """
        try:
            es = ExternalSource
            i_s_mi_join_table = PostInteractionsSourceMiJoin
            i = PostInteractions
            stjt = SourceTagJoinTable
            tlt = TagLookupTable

            query = (
                db.select(
                    es.source_id,
                    es.grn_title,
                    es.image_url,
                    es.source_name,
                    es.comments,
                    es.cyjs_layout,
                    stjt.tag_name,
                    tlt.tag_group
                )
                .join(i_s_mi_join_table, i_s_mi_join_table.source_id == es.source_id)
                .join(i, i.interaction_id == i_s_mi_join_table.interaction_id)
                .join(stjt, es.source_id == stjt.source_id)
                .join(tlt, stjt.tag_name == tlt.tag_name)
                .filter(
                    ((i.entity_1 == AGI_1) | (i.entity_2 == AGI_1))  # Matches first AGI
                    | ((i.entity_1 == AGI_2) | (i.entity_2 == AGI_2))  # Matches second AGI
                )
                .filter(es.grn_title.isnot(None))
            )
            rows = db.session.execute(query).all()

            result_dict = {}

            for row in rows:
                source_id = row.source_id

                if source_id not in result_dict:
                    result_dict[source_id] = {
                        "source_id": row.source_id,
                        "grn_title": row.grn_title,
                        "image_url": row.image_url,
                        "source_name": row.source_name,
                        "comments": row.comments,
                        "cyjs_layout": row.cyjs_layout,
                        "tags": set()
                    }

                result_dict[source_id]["tags"].add(f"{row.tag_name}:{row.tag_group}")  # ensures uniqueness automatically with `set`

            result = [
                {
                    **data,
                    "tags": "|".join(sorted(data["tags"]))
                }
                for data in result_dict.values()
            ]

            if len(result) == 0:
                return BARUtils.error_exit("Both AGI invalid"), 400
            return BARUtils.success_exit(result)

        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400


@itrns.route("/get_all_grns")
class GetAllGRNs(Resource):
    def get(self):
        """
        Returns
        """
        result = []

        try:
            es = ExternalSource
            stjt = SourceTagJoinTable
            tlt = TagLookupTable
            query = (
                db.select(
                    es,
                    stjt.tag_name,
                    tlt.tag_group
                )
                .join(stjt, es.source_id == stjt.source_id)
                .join(tlt, stjt.tag_name == tlt.tag_name)
            )
            rows = db.session.execute(query).all()

            src_tag_match = {}
            for ex, name, group in rows:
                if ex.source_id not in src_tag_match:
                    src_tag_match[ex.source_id] = [f"{name}:{group}"]
                else:
                    src_tag_match[ex.source_id].append(f"{name}:{group}")

            one_source = {}

            for ex, name, group in rows:
                source_id = ex.source_id
                if source_id not in one_source:
                    one_source[source_id] = {
                        "source_id": source_id,
                        "source_name": ex.source_name,
                        "comments": ex.comments,
                        "date_uploaded": ex.date_uploaded.isoformat() if ex.date_uploaded else None,
                        "url": ex.url,
                        "image_url": ex.image_url,
                        "grn_title": ex.grn_title,
                        "cyjs_layout": ex.cyjs_layout,
                        "tag": "|".join(src_tag_match[ex.source_id])
                    }
                    result.append(one_source[source_id])

            return BARUtils.success_exit(result)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400
