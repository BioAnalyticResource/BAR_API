from api import summarization_db as db
from api.models.summarization import Users, Requests
from api.utils.bar_utils import BARUtils
from flask import request
from flask_restx import Namespace, Resource
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError
import smtplib
import os
import uuid
import requests
import pandas
from cryptography.fernet import Fernet

CAPTCHA_KEY_FILE = "/home/bpereira/data/bar.summarization/key"

api_manager = Namespace("API Manager", description="API Manager", path="/api_manager")


class ApiManagerUtils:
    @staticmethod
    def check_admin_pass(user_key):
        # Replace below with key from script in /home/bpereira/dev/pw-key
        # key = app.config['ADMIN_ENCRYPT_KEY']
        cipher_suite = Fernet(user_key)
        with open("/home/bpereira/dev/pw-script/key.bin", "rb") as f:
            for line in f:
                encrypted_key = line
        uncipher_text = cipher_suite.decrypt(encrypted_key)
        plain_text_encryptedpassword = bytes(uncipher_text).decode("utf-8")
        if user_key == plain_text_encryptedpassword:
            return True
        else:
            return False

    @staticmethod
    def send_email():
        """Sends a notification email alerting admins about new requests"""
        if request.method == "POST":
            smtp_server = "localhost"
            sender_email = "notify@bar.utoronto.ca"
            receiver_email = "nicholas.provart@utoronto.ca"
            message = """\
            Subject: New API key request(s)

            There have been new requests for API keys since your last visit.
            You can approve or reject them at http://bar.utoronto.ca/~bpereira/webservices/bar-api-request-manager/build/index.html."""

            with smtplib.SMTP(smtp_server) as server:
                server.ehlo()
                server.sendmail(sender_email, receiver_email, message)


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
                return BARUtils.error_exit("API key not found"), 404
            else:
                if row.uses_left > 0:
                    return BARUtils.success_exit("True")
                else:
                    return BARUtils.error_exit("API key expired"), 401


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
                    ApiManagerUtils.send_email()
                    return BARUtils.success_exit("Request sent")
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
