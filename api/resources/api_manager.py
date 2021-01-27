import pandas
from api import db
from api.models.summarization import Users, Requests
from api.utils.bar_utils import BARUtils
from flask import request
from flask_restx import Namespace, Resource
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError
from cryptography.fernet import Fernet
import uuid
import requests


ADMIN_PASSWORD_FILE = '/home/bpereira/dev/pw-script/key.bin'
CAPTCHA_KEY_FILE = '/home/bpereira/data/bar.summarization/key'

api_manager = Namespace('API Manager',
                        description='API Manager',
                        path='/api_manager')


class ApiManagerUtils:
    @staticmethod
    def check_admin_pass(user_key):
        # Replace below with key from script in /home/bpereira/dev/pw-key
        key = b'jbqwbghmdv8okVqvqVL-KWc7cMqRU9FLpDIew6TTBoA='
        cipher_suite = Fernet(key)
        with open(ADMIN_PASSWORD_FILE, 'rb') as f:
            for line in f:
                encrypted_key = line
        uncipher_text = cipher_suite.decrypt(encrypted_key)
        plain_text_encryptedpassword = bytes(uncipher_text).decode("utf-8")
        if user_key == plain_text_encryptedpassword:
            return True
        else:
            return False


@api_manager.route('/validate_admin_password', methods=["POST"], doc=False)
class ApiManagerValidate(Resource):
    def post(self):
        """Verify admin password
        """
        if(request.method == "POST"):
            response_json = request.get_json()
            user_key = response_json['key']
            if ApiManagerUtils.check_admin_pass(user_key):
                return BARUtils.success_exit(True)
            else:
                return BARUtils.success_exit(False)


@api_manager.route('/validate_api_key', methods=["POST"], doc=False)
class ApiManagerValidateKey(Resource):
    def post(self):
        """Verify if an API key provided by the user exists in the database
        """
        if(request.method == "POST"):
            tbl = Users()
            json = request.get_json()
            key = json["key"]
            try:
                row = tbl.query.filter_by(api_key=key).first()
            except SQLAlchemyError:
                return BARUtils.error_exit("Internal server error"), 500
            if(row is None):
                return BARUtils.success_exit(False)
            else:
                if row.uses_left > 0:
                    return BARUtils.success_exit(True)
                else:
                    return BARUtils.success_exit(False)


@api_manager.route('/request', methods=["POST"], doc=False)
class ApiManagerRequest(Resource):
    def post(self):
        if(request.method == "POST"):
            response_json = request.get_json()
            password = response_json["password"]
            if ApiManagerUtils.check_admin_pass(password):
                df = pandas.DataFrame.from_records([response_json])
                con = db.get_engine(bind='summarization')
                try:
                    reqs = Requests()
                    users = Users()
                    row_req = reqs.query.filter_by(email=df.email)
                    row_users = users.query.filter_by(email=df.email)
                    if(row_req is None and row_users is None):
                        df.to_sql('requests', con, if_exists='append', index=False)
                    else:
                        return BARUtils.error_exit("E-mail already in use"), 409
                except SQLAlchemyError:
                    return BARUtils.error_exit("Internal server error"), 500
            else:
                return BARUtils.error_exit("Forbidden"), 403


@api_manager.route('/get_pending_requests', methods=["GET"], doc=False)
class ApiManagerGetPending(Resource):
    def get(self):
        """Returns list of pending requests from the database
        """
        if(request.method == "GET"):
            response_json = request.get_json()
            password = response_json["password"]
            if ApiManagerUtils.check_admin_pass(password):
                table = Requests()
                values = []
                try:
                    rows = table.query.filter_by().all()
                except SQLAlchemyError:
                    return BARUtils.error_exit("Internal server error"), 500
                [values.append({"first_name": row.first_name,
                                "last_name": row.last_name, "email": row.email,
                                "telephone": row.telephone,
                                "contact_type": row.contact_type,
                                "notes": row.notes}) for row in rows]
                return BARUtils.success_exit(values)
            else:
                return BARUtils.error_exit("Forbidden"), 403


@api_manager.route('/reject_request', methods=["POST"], doc=False)
class ApiManagerRejectRequest(Resource):
    def post(self):
        """Delete a request from the database
        """
        if(request.method == "POST"):
            response_json = request.get_json()
            password = response_json["password"]
            if ApiManagerUtils.check_admin_pass(password):
                response_json = request.get_json()
                table = Requests()
                try:
                    el = table.query.filter_by(email=response_json['email']).one()
                except SQLAlchemyError:
                    return BARUtils.error_exit("Internal server error"), 500
                db.session.delete(el)
                db.session.commit()
                # table.query.filter_by(email=response_json['email']).delete()
                return BARUtils.success_exit(True)
            else:
                return BARUtils.error_exit("Forbidden"), 403


@api_manager.route('/approve_request/<string:email>', methods=["GET"], doc=False)
class ApiManagerApproveRequest(Resource):
    def get(self, email):
        """Approve a request from the database and add it to the Users table
        """
        if(request.method == "GET"):
            response_json = request.get_json()
            password = response_json["password"]
            if ApiManagerUtils.check_admin_pass(password):
                table = Requests()
                values = []
                try:
                    rows = table.query.filter_by(email=email).all()
                except SQLAlchemyError:
                    return BARUtils.error_exit("Internal server error"), 500
                key = uuid.uuid4().hex
                [values.append({"first_name": row.first_name,
                                "last_name": row.last_name, "email": row.email,
                                "telephone": row.telephone,
                                "contact_type": row.contact_type,
                                "date_added": datetime.now(),
                                "status": "user",
                                "api_key": key,
                                "uses_left": 25}) for row in rows]
                df = pandas.DataFrame.from_records([values[0]])
                con = db.get_engine(bind='summarization')
                try:
                    df.to_sql('users', con, if_exists='append', index=False)
                    el = table.query.filter_by(email=email).one()
                    db.session.delete(el)
                except SQLAlchemyError:
                    return BARUtils.error_exit("Internal server error"), 500
                return BARUtils.success_exit(key)
            else:
                return BARUtils.error_exit("Forbidden"), 403


@api_manager.route('/validate_captcha', methods=["POST"], doc=False)
class ApiManagerCaptchaValidate(Resource):
    def post():
        """Validates a reCaptcha value using our secret token
        """
        if (request.method == "POST"):
            json = request.get_json()
            value = json['response']
            with open(CAPTCHA_KEY_FILE) as f:
                key = f.read()
            key = key[:-1]  # Remove newline
            ret = requests.post("https://www.google.com/recaptcha/api/siteverify", data={'secret': key, 'response': value})
            return BARUtils.success_exit(ret.text)
