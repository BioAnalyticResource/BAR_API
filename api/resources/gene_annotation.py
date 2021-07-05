from flask_restx import Namespace, Resource
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api.models.eplant_poplar import GeneAnnotation as eplant_poplar_annotation
from api.models.eplant_tomato import GeneAnnotation as eplant_tomato_annotation
from api.models.eplant2 import AgiAnnotation, TAIR10, GeneRIFs
from api.utils.bar_utils import BARUtils


gene_annotation = Namespace(
    "Gene Annotation", description="Gene annotation API", path="/gene_annotation"
)

@gene_annotation.route("/<string:query>")
class GeneAnnotation(Resource):
    @gene_annotation.param("query", _in="path", default="alpha-1 protein")
    def get(self, species="", query=""):
        """
        Endpoint returns gene locus for given gene keywords 
        """
        annotation_db_list={'tomato':eplant_tomato_annotation,'poplar':eplant_poplar_annotation,'arabidopsis':[AgiAnnotation, TAIR10, GeneRIFs]}

        species = escape(species.lower())
        query = escape(query.capitalize())

        res=[]
        db=annotation_db_list.get(species,False)
        for species,db in annotation_db_list.items():           
            try:
                if species=="arabidopsis":
                    
                    agi_info=AgiAnnotation.query.filter(AgiAnnotation.annotation.op('regexp')(query)).all()
                    tair10_curator_info=TAIR10.query.filter(TAIR10.Curator_summary.op('regexp')(query)).all()
                    tair10_computational_info=TAIR10.query.filter(TAIR10.Computational_description.op('regexp')(query)).all()
                    RIFs_info=GeneRIFs.query.filter(GeneRIFs.RIF.op('regexp')(query)).all()

                    res+=[{'gene':i.agi,'species':species,'gene_annotation':i.annotation} for i in agi_info]
                    res+=[{'gene':i.Model_name,'species':species,'gene_annotation':i.Curator_summary} for i in tair10_curator_info]
                    res+=[{'gene':i.Model_name,'species':species,'gene_annotation':i.Computational_description} for i in tair10_computational_info]
                    res+=[{'gene':i.gene,'species':species,'gene_annotation':i.RIF} for i in RIFs_info]
                else:
                    rows = db.query.filter(db.annotation.op('regexp')(query)).all()
                    res=[{'gene':i.gene,'species':species,'gene_annotation':i.annotation} for i in rows]
            except OperationalError:
                return BARUtils.error_exit("An internal error has occurred"), 500

        if len(res) == 0:
            return (
                BARUtils.error_exit(
                    "There are no data found for the given query"
                ),
                400,
            )
        else:
            # return first 10 matches
            return {
                "status": "success",
                "query": query,
                "result": res[:10]
            }

