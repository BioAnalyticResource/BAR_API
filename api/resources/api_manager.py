import uuid

from api import summarization_db as db
from api.models.summarization import Users, Requests
from api.utils.bar_utils import BARUtils
from api.utils.api_manager_utils import ApiManagerUtils
from flask import request
from flask_restx import Namespace, Resource
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import object_mapper
import pandas

CAPTCHA_KEY_FILE = "/home/bpereira/data/bar.summarization/key"
api_manager = Namespace("API Manager", description="API Manager", path="/api_manager")


@api_manager.route("/validate_admin_password", methods=["POST"], doc=False)
class ApiManagerValidate(Resource):
    def post(self):
        """Verify admin password"""
        response_json = request.get_json()
        password = response_json["password"]
        if ApiManagerUtils.check_admin_pass(password):
            return BARUtils.success_exit(True)
        else:
            return BARUtils.success_exit(False)


@api_manager.route("/validate_api_key", methods=["POST"], doc=False)
class ApiManagerValidateKey(Resource):
    def post(self):
        """Verify if an API key provided by the user exists in the database"""
        tbl = Users()
        json = request.get_json()
        key = json["key"]
        try:
            row = tbl.query.filter_by(api_key=key).first()
        except SQLAlchemyError:
            return BARUtils.error_exit("Internal server error"), 500

        if row is None:
            return BARUtils.error_exit("API key not found"), 404
        else:
            if row.uses_left > 0:
                return BARUtils.success_exit(True)
            else:
                return BARUtils.error_exit("API key expired"), 401


@api_manager.route("/request", methods=["POST"], doc=False)
class ApiManagerRequest(Resource):
    def post(self):
        captchaVal = request.headers.get("captchaVal")
        if ApiManagerUtils.validate_captcha(captchaVal):
            response_json = request.get_json()
            df = pandas.DataFrame.from_records([response_json])
            con = db.get_engine(bind="summarization")
            try:
                reqs = Requests()
                users = Users()
                row_req = reqs.query.filter_by(email=df.email[0]).first()
                row_users = users.query.filter_by(email=df.email[0]).first()

                if row_req is None and row_users is None:
                    df.to_sql("requests", con, if_exists="append", index=False)
                    ApiManagerUtils.send_email_notification()
                    return BARUtils.success_exit("Data added")
                else:
                    return BARUtils.error_exit("E-mail already in use"), 409
            except SQLAlchemyError:
                return BARUtils.error_exit("Internal server error"), 500
        else:
            return BARUtils.error_exit("Failed Captcha verification")


@api_manager.route("/get_pending_requests", methods=["POST"], doc=False)
class ApiManagerGetPending(Resource):
    def post(self):
        """Returns list of pending requests from the database"""
        response_json = request.get_json()
        password = response_json["password"]
        if ApiManagerUtils.check_admin_pass(password):
            table = Requests()
            values = []
            try:
                rows = table.query.filter_by().all()
            except SQLAlchemyError:
                return BARUtils.error_exit("Internal server error"), 500
            [
                values.append(
                    {
                        "first_name": row.first_name,
                        "last_name": row.last_name,
                        "email": row.email,
                        "notes": row.notes,
                    }
                )
                for row in rows
            ]
            return BARUtils.success_exit(values)
        else:
            return BARUtils.error_exit("Forbidden"), 403


@api_manager.route("/reject_request", methods=["POST"], doc=False)
class ApiManagerRejectRequest(Resource):
    def post(self):
        """Delete a request from the database"""
        response_json = request.get_json()
        password = response_json["password"]
        if ApiManagerUtils.check_admin_pass(password):
            response_json = request.get_json()
            table = Requests()
            try:
                el = table.query.filter_by(email=response_json["email"]).one()
            except SQLAlchemyError:
                return BARUtils.error_exit("Internal server error"), 500
            db.session.delete(el)
            db.session.commit()
            # table.query.filter_by(email=response_json['email']).delete()
            return BARUtils.success_exit(True)
        else:
            return BARUtils.error_exit("Forbidden"), 403


@api_manager.route("/approve_request", methods=["POST"], doc=False)
class ApiManagerApproveRequest(Resource):
    def post(self):
        """Approve a request from the database and add it to the Users table"""
        response_json = request.get_json()
        email = response_json["email"]
        password = response_json["password"]
        if ApiManagerUtils.check_admin_pass(password):
            table = Requests()
            values = []
            try:
                rows = table.query.filter_by(email=email).all()
            except SQLAlchemyError:
                return BARUtils.error_exit("Internal server error"), 500
            key = uuid.uuid4().hex
            [
                values.append(
                    {
                        "first_name": row.first_name,
                        "last_name": row.last_name,
                        "email": row.email,
                        "date_added": datetime.now(),
                        "status": "user",
                        "api_key": key,
                        "uses_left": 100,
                    }
                )
                for row in rows
            ]
            df = pandas.DataFrame.from_records([values[0]])
            con = db.get_engine(bind="summarization")
            try:
                df.to_sql("users", con, if_exists="append", index=False)

                class UserTable(db.Model):
                    __bind_key__ = "summarization"
                    __tablename__ = key
                    __table_args__ = (
                        db.Index(
                            "data_probeset_id",
                            "data_probeset_id",
                            "data_bot_id",
                            "data_signal",
                        ),
                    )
                    proj_id = db.Column(db.String(5), nullable=False)
                    sample_id = db.Column(
                        db.Integer, nullable=False, server_default=db.FetchedValue()
                    )
                    data_probeset_id = db.Column(
                        db.String(24), nullable=False, primary_key=True
                    )
                    data_signal = db.Column(
                        db.Float, server_default=db.FetchedValue(), primary_key=True
                    )
                    data_bot_id = db.Column(
                        db.String(32), nullable=False, primary_key=True
                    )

                UserTable.__table__.create(
                    db.session().get_bind(object_mapper(UserTable())), checkfirst=True
                )
                el = table.query.filter_by(email=email).one()
                db.session.delete(el)
                db.session.commit()
            except SQLAlchemyError:
                return BARUtils.error_exit("Internal server error"), 500
            return BARUtils.success_exit(key)
        else:
            return BARUtils.error_exit("Forbidden"), 403
