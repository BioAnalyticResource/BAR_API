from api import summarization_db as db
from api.models.summarization import Users, Requests
from api.utils.bar_utils import BARUtils
from flask import request
from flask_restx import Namespace, Resource
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError
import os
import uuid
import requests
import pandas


CAPTCHA_KEY_FILE = "/home/bpereira/data/bar.summarization/key"

api_manager = Namespace("API Manager", description="API Manager", path="/api_manager")


class ApiManagerUtils:
    @staticmethod
    def check_admin_pass(user_key):
        if user_key == os.environ.get("API_MANAGER_KEY"):
            return True
        else:
            return False


@api_manager.route("/validate_admin_password", methods=["POST"], doc=False)
class ApiManagerValidate(Resource):
    def post(self):
        """Verify admin password"""
        if request.method == "POST":
            response_json = request.get_json()
            user_key = response_json["key"]
            if ApiManagerUtils.check_admin_pass(user_key):
                return BARUtils.success_exit(True)
            else:
                return BARUtils.success_exit(False)


@api_manager.route("/validate_api_key", methods=["POST"], doc=False)
class ApiManagerValidateKey(Resource):
    def post(self):
        """Verify if an API key provided by the user exists in the database"""
        if request.method == "POST":
            tbl = Users()
            json = request.get_json()
            key = json["key"]
            try:
                row = tbl.query.filter_by(api_key=key).first()
            except SQLAlchemyError:
                return BARUtils.error_exit("Internal server error"), 500

            # Todo: I guess this is work in progress.
            if row is None:
                return BARUtils.success_exit("Do data found")
            else:
                if row.uses_left > 0:
                    return BARUtils.success_exit("True")
                else:
                    return BARUtils.success_exit("False")


@api_manager.route("/request", methods=["POST"], doc=False)
class ApiManagerRequest(Resource):
    def post(self):
        if request.method == "POST":
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
                else:
                    return BARUtils.error_exit("E-mail already in use"), 409
            except SQLAlchemyError:
                return BARUtils.error_exit("Internal server error"), 500


@api_manager.route("/get_pending_requests", methods=["POST"], doc=False)
class ApiManagerGetPending(Resource):
    def post(self):
        """Returns list of pending requests from the database"""
        if request.method == "POST":
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
                            "telephone": row.telephone,
                            "contact_type": row.contact_type,
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
        if request.method == "POST":
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
        if request.method == "POST":
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
                            "telephone": row.telephone,
                            "contact_type": row.contact_type,
                            "date_added": datetime.now(),
                            "status": "user",
                            "api_key": key,
                            "uses_left": 25,
                        }
                    )
                    for row in rows
                ]
                df = pandas.DataFrame.from_records([values[0]])
                con = db.get_engine(bind="summarization")
                try:
                    df.to_sql("users", con, if_exists="append", index=False)
                    el = table.query.filter_by(email=email).one()
                    db.session.delete(el)
                except SQLAlchemyError:
                    return BARUtils.error_exit("Internal server error"), 500
                return BARUtils.success_exit(key)
            else:
                return BARUtils.error_exit("Forbidden"), 403


@api_manager.route("/validate_captcha", methods=["POST"], doc=False)
class ApiManagerCaptchaValidate(Resource):
    def post(self):
        """Validates a reCaptcha value using our secret token"""
        if request.method == "POST":
            json = request.get_json()
            value = json["response"]
            key = os.environ.get("CAPTCHA_KEY")
            if key:
                ret = requests.post(
                    "https://www.google.com/recaptcha/api/siteverify",
                    data={"secret": key, "response": value},
                )
                return BARUtils.success_exit(ret.text)
            else:
                return BARUtils.error_exit("Forbidden: CAPTCHA key is not found"), 403
