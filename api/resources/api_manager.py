from api import summarization_db as db
from api.models.summarization import Users, Requests
from api.utils.bar_utils import BARUtils
from flask import request
from flask_restx import Namespace, Resource
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.types import String, Float
import os
import uuid
import requests
import pandas
from cryptography.fernet import Fernet
from smtplib import SMTP_SSL
from ssl import create_default_context
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

CAPTCHA_KEY_FILE = "/home/bpereira/data/bar.summarization/key"

api_manager = Namespace("API Manager", description="API Manager", path="/api_manager")


class ApiManagerUtils:
    @staticmethod
    def check_admin_pass(password):
        # Replace below with key from script in /home/bpereira/dev/pw-key
        key = os.environ.get("ADMIN_ENCRYPT_KEY")
        cipher_suite = Fernet(key)
        with open(os.environ.get("ADMIN_PASSWORD_FILE"), "rb") as f:
            for line in f:
                encrypted_key = line
        uncipher_text = cipher_suite.decrypt(encrypted_key)
        plain_text_encryptedpassword = bytes(uncipher_text).decode("utf-8")
        if password == plain_text_encryptedpassword:
            return True
        else:
            return False

    @staticmethod
    def validate_captcha(value):
        """Validates a reCaptcha value using our secret token"""
        if(os.environ.get("BAR")):
            with open(CAPTCHA_KEY_FILE, "rb") as f:
                for line in f:
                    key = line
            if key:
                ret = requests.post(
                    "https://www.google.com/recaptcha/api/siteverify",
                    data={"secret": key, "response": value}
                )
                return ret.json()["success"]
            else:
                return False
        else:
            return True

    @staticmethod
    def send_email_notification():
        if os.environ.get("BAR"):
            with open(os.environ.get("ADMIN_EMAIL"), "r") as f:
                for line in f:
                    recipient = line
            port = 465
            key = os.environ.get("EMAIL_PASS_KEY")
            cipher_suite = Fernet(key)
            with open(os.environ.get("EMAIL_PASS_FILE"), "rb") as f:
                for line in f:
                    encrypted_key = line
            uncipher_text = cipher_suite.decrypt(encrypted_key)
            password = bytes(uncipher_text).decode("utf-8")
            context = create_default_context()
            smtp_server = "smtp.gmail.com"
            sender_email = "bar.summarization@gmail.com"
            subject = "[Bio-Analytic Resource] New API key request"
            text = """\
                There is a new API key request.
                You can approve or reject it at http://bar.utoronto.ca/~bpereira/webservices/bar-request-manager/build/index.html
            """
            m_text = MIMEText(text, _subtype="plain", _charset="UTF-8")
            msg = MIMEMultipart()
            msg["From"] = sender_email
            msg["To"] = recipient
            msg["Subject"] = subject
            msg.attach(m_text)
            with SMTP_SSL(smtp_server, port, context=context) as server:
                server.login("bar.summarization@gmail.com", password)
                server.sendmail(sender_email, recipient, msg.as_string())


@api_manager.route("/validate_admin_password", methods=["POST"], doc=False)
class ApiManagerValidate(Resource):
    def post(self):
        """Verify admin password"""
        if request.method == "POST":
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
        if request.method == "POST":
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
        if request.method == "POST":
            captchaVal = request.headers.get("captchaVal")
            if(ApiManagerUtils.validate_captcha(captchaVal)):
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
                            "date_added": datetime.now(),
                            "status": "user",
                            "api_key": key,
                            "uses_left": 100,
                        }
                    )
                    for row in rows
                ]
                df = pandas.DataFrame.from_records([values[0]])
                values_df = pandas.DataFrame(columns=["Gene", "Sample", "Value"])
                con = db.get_engine(bind="summarization")
                try:
                    df.to_sql("users", con, if_exists="append", index=False)
                    values_df.to_sql(
                        key,
                        con,
                        index_label="index",
                        dtype={
                            values_df.index.name: String(42),
                            "Gene": String(32),
                            "Sample": String(32),
                            "Value": Float,
                        },
                        if_exists="append",
                        index=True,
                    )
                    el = table.query.filter_by(email=email).one()
                    db.session.delete(el)
                    db.session.commit()
                except SQLAlchemyError:
                    return BARUtils.error_exit("Internal server error"), 500
                return BARUtils.success_exit(key)
            else:
                return BARUtils.error_exit("Forbidden"), 403
