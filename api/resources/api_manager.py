import pandas
from api import db
from api.models.requests import Requests
from api.models.users import Users
from flask import request, jsonify
from flask_restx import Namespace, Resource
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError
from cryptography.fernet import Fernet
import uuid


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
                return True
            else:
                return False


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
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error
            if(row is None):
                return {'success': False, 'error': 'Key not found', 'error_code': 404}
            else:
                if row.uses_left > 0:
                    return True
                else:
                    return {'success': False, 'error': 'Key expired', 'error_code': 403}


@api_manager.route('/request', methods=["POST"])
class ApiManagerRequest(Resource):
    def post(self):
        if(request.method == "POST"):
            response_json = request.get_json()
            df = pandas.DataFrame.from_records([response_json])
            print(df.email)
            con = db.get_engine(bind='summarization')
            try:
                reqs = Requests()
                users = Users()
                row_req = reqs.query.filter_by(email=df.email)
                row_users = users.query.filter_by(email=df.email)
                if(row_req is None and row_users is None):
                    df.to_sql('requests', con, if_exists='append', index=False)
                else:
                    return {'success': False, 'error': 'E-mail already in use.', 'error_code': 409}
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error


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
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error
            [values.append({"first_name": row.first_name,
                            "last_name": row.last_name, "email": row.email,
                            "telephone": row.telephone,
                            "contact_type": row.contact_type,
                            "notes": row.notes}) for row in rows]
            return jsonify(values)


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
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error
            db.session.delete(el)
            db.session.commit()
            # table.query.filter_by(email=response_json['email']).delete()
            return True


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
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error
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
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error
            return key
