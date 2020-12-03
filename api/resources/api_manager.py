import pandas
from api import db
from api.models.api_manager import Users
from api.models.api_manager import Requests
from flask import request, jsonify
from flask_restx import Namespace, Resource
from datetime import datetime
import uuid
from cryptography.fernet import Fernet


api_manager = Namespace('API Manager',
                        description='API Manager',
                        path='/api_manager')


@api_manager.route('/validate', methods=["POST"])
class ApiManagerValidate(Resource):
    def post(self):
        if(request.method == "POST"):
            response_json = request.get_json()
            # Validate API key
            user_key = response_json['key']
            key = b'dsoR_Ke7cZiX5F1oFES8RuabLHX0puUOETlPGrX-bdE='
            cipher_suite = Fernet(key)
            with open('./key.bin', 'rb') as f:
                for line in f:
                    encrypted_key = line
            uncipher_text = cipher_suite.decrypt(encrypted_key)
            plain_text_encryptedpassword = bytes(uncipher_text).decode("utf-8")
            print(user_key)
            print(plain_text_encryptedpassword)
            if user_key == plain_text_encryptedpassword:
                print("true")
                return True
            else:
                print("false")
                return False


@api_manager.route('/request', methods=["POST"])
class ApiManagerRequest(Resource):
    def post(self):
        if(request.method == "POST"):
            response_json = request.get_json()
            df = pandas.DataFrame.from_records([response_json])
            con = db.get_engine(bind='keys')
            df.to_sql('requests', con, if_exists='append', index=False)


@api_manager.route('/get_pending_requests', methods=["GET"])
class ApiManagerGetPending(Resource):
    def get(self):
        if(request.method == "GET"):
            table = Requests()
            values = []
            rows = table.query.filter_by().all()
            [values.append({"first_name": row.first_name,
                            "last_name": row.last_name, "email": row.email,
                            "telephone": row.telephone,
                            "contact_type": row.contact_type,
                            "notes": row.notes}) for row in rows]
            return jsonify(values)


@api_manager.route('/reject_request', methods=["POST"])
class ApiManagerRejectRequest(Resource):
    def post(self):
        if(request.method == "POST"):
            response_json = request.get_json()
            table = Requests()
            el = table.query.filter_by(email=response_json['email']).one()
            print(el)
            db.session.delete(el)
            db.session.commit()
            # table.query.filter_by(email=response_json['email']).delete()
            return True


@api_manager.route('/approve_request', methods=["GET"])
class ApiManagerApproveRequest(Resource):
    def get(self):
        if(request.method == "GET"):
            email = request.args.get('email')
            table = Requests()
            values = []
            rows = table.query.filter_by(email=email).all()
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
            con = db.get_engine(bind='keys')
            df.to_sql('users', con, if_exists='append', index=False)
            el = table.query.filter_by(email=email).one()
            db.session.delete(el)
            return key
