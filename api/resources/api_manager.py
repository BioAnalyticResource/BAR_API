import pandas
from api import db
from api.models.requests import Requests
from api.models.users import Users
from api.utils.bar_utils import BARUtils
from flask import request
from flask_restx import Namespace, Resource
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError
from cryptography.fernet import Fernet
import uuid
import requests


ADMIN_PASSWORD_FILE = ''

api_manager = Namespace('API Manager',
                        description='API Manager',
                        path='/api_manager')


@api_manager.route('/validate_admin_password', methods=["POST"])
class ApiManagerValidate(Resource):
    def post(self):
        """Verify admin password
        """
        if(request.method == "POST"):
            response_json = request.get_json()
            # Validate API key
            user_key = response_json['key']
            # Replace below
            key = b'fNtXVDxom9YGg3D9BHwyRAvsyJREc-1yD7gcy5Jpxbc='
            cipher_suite = Fernet(key)
            with open('./key.bin', 'rb') as f:
                for line in f:
                    encrypted_key = line
            uncipher_text = cipher_suite.decrypt(encrypted_key)
            plain_text_encryptedpassword = bytes(uncipher_text).decode("utf-8")
            if user_key == plain_text_encryptedpassword:
                return BARUtils.success_exit(True)
            else:
                return BARUtils.success_exit(False)


@api_manager.route('/validate_api_key', methods=["POST"])
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


@api_manager.route('/request', methods=["POST"])
class ApiManagerRequest(Resource):
    def post(self):
        if(request.method == "POST"):
            response_json = request.get_json()
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


@api_manager.route('/get_pending_requests', methods=["GET"])
class ApiManagerGetPending(Resource):
    def get(self):
        """Returns list of pending requests from the database
        """
        if(request.method == "GET"):
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


@api_manager.route('/reject_request', methods=["POST"])
class ApiManagerRejectRequest(Resource):
    def post(self):
        """Delete a request from the database
        """
        if(request.method == "POST"):
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


@api_manager.route('/approve_request/<string:email>', methods=["GET"])
class ApiManagerApproveRequest(Resource):
    def get(self, email):
        """Approve a request from the database and add it to the Users table
        """
        if(request.method == "GET"):
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


@api_manager.route('/validate_captcha', methods=["POST"])
class ApiManagerCaptchaValidate(Resource):
    def post():
        """Validates a reCaptcha value using our secret token
        """
        if (request.method == "POST"):
            json = request.get_json()
            value = json['response']
            ret = requests.post("https://www.google.com/recaptcha/api/siteverify", data={'secret': '6LeQou4ZAAAAAEpRcYB0AYksN-R8gXj9iXucTcNx', 'response': value})
            return BARUtils.success_exit(ret.text)
