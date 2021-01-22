import pandas
from api import db
from api.models.mykeys import Requests, Users
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


@api_manager.route('/validate_admin_password', methods=['POST'], doc=False)
class ApiManagerValidate(Resource):
    def post(self):
        if request.method == 'POST':
            response_json = request.get_json()

            # Validate API key
            user_key = response_json['key']

            # Replace below
            key = b'fNtXVDxom9YGg3D9BHwyRAvsyJREc-1yD7gcy5Jpxbc='
            cipher_suite = Fernet(key)

            with open('./key.bin', 'rb') as f:
                for line in f:
                    encrypted_key = line

            deciphered_text = cipher_suite.decrypt(encrypted_key)
            plain_text_encrypted_password = bytes(deciphered_text).decode('utf-8')

            if user_key == plain_text_encrypted_password:
                return True
            else:
                return False


@api_manager.route('/validate_api_key', methods=['POST'], doc=False)
class ApiManagerValidateKey(Resource):
    def post(self):
        if request.method == 'POST':
            tbl = Users()
            json = request.get_json()
            key = json['key']
            try:
                row = tbl.query.filter_by(api_key=key).first()
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error

            if row is None:
                return False
            else:
                if row.uses_left > 0:
                    return True
                else:
                    return False


@api_manager.route('/request', methods=['POST'], doc=False)
class ApiManagerRequest(Resource):
    def post(self):
        if request.method == 'POST':
            response_json = request.get_json()
            df = pandas.DataFrame.from_records([response_json])
            con = db.get_engine(bind='mykeys')

            try:
                df.to_sql('requests', con, if_exists='append', index=False)
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error


@api_manager.route('/get_pending_requests', methods=['GET'], doc=False)
class ApiManagerGetPending(Resource):
    def get(self):
        if request.method == 'GET':
            table = Requests()
            values = []

            try:
                rows = table.query.filter_by().all()
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error

            [values.append({'first_name': row.first_name,
                            'last_name': row.last_name, 'email': row.email,
                            'telephone': row.telephone,
                            'contact_type': row.contact_type,
                            'notes': row.notes}) for row in rows]

            return jsonify(values)


@api_manager.route('/reject_request', methods=['POST'], doc=False)
class ApiManagerRejectRequest(Resource):
    def post(self):
        if request.method == 'POST':
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


@api_manager.route('/approve_request', methods=['GET'], doc=False)
class ApiManagerApproveRequest(Resource):
    def get(self):
        if request.method == 'GET':
            email = request.args.get('email')
            table = Requests()
            values = []

            try:
                rows = table.query.filter_by(email=email).all()
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error

            key = uuid.uuid4().hex
            [values.append({'first_name': row.first_name,
                            'last_name': row.last_name, 'email': row.email,
                            'telephone': row.telephone,
                            'contact_type': row.contact_type,
                            'date_added': datetime.now(),
                            'status': 'user',
                            'api_key': key,
                            'uses_left': 25}) for row in rows]

            df = pandas.DataFrame.from_records([values[0]])

            con = db.get_engine(bind='keys')
            try:
                df.to_sql('users', con, if_exists='append', index=False)
                el = table.query.filter_by(email=email).one()
                db.session.delete(el)
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error

            return key
