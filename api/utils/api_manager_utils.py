import os
import requests
from cryptography.fernet import Fernet
from smtplib import SMTP_SSL
from ssl import create_default_context
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

CAPTCHA_KEY_FILE = "/home/bpereira/data/bar.summarization/key"


class ApiManagerUtils:
    @staticmethod
    def check_admin_pass(password):
        # Replace below with key from script in /home/bpereira/dev/pw-key
        key = os.environ.get("ADMIN_ENCRYPT_KEY")
        cipher_suite = Fernet(key)

        with open(os.environ.get("ADMIN_PASSWORD_FILE"), "rb") as f:
            for line in f:
                encrypted_key = line

        decipher_text = cipher_suite.decrypt(encrypted_key)
        plain_text_encrypted_password = bytes(decipher_text).decode("utf-8")

        if password == plain_text_encrypted_password:
            return True
        else:
            return False

    @staticmethod
    def validate_captcha(value):
        """Validates a reCaptcha value using our secret token"""
        if os.environ.get("BAR"):
            with open(CAPTCHA_KEY_FILE, "rb") as f:
                for line in f:
                    key = line

            if key:
                ret = requests.post(
                    "https://www.google.com/recaptcha/api/siteverify",
                    data={"secret": key, "response": value},
                )
                return ret.json()["success"]
            else:
                return False
        else:
            return True

    @staticmethod
    def send_email_notification(subject, msg):
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

            decipher_text = cipher_suite.decrypt(encrypted_key)
            password = bytes(decipher_text).decode("utf-8")
            context = create_default_context()
            smtp_server = "smtp.gmail.com"
            sender_email = "bar.summarization@gmail.com"
            text = msg
            m_text = MIMEText(text, _subtype="plain", _charset="UTF-8")
            msg = MIMEMultipart()
            msg["From"] = sender_email
            msg["To"] = recipient
            msg["Subject"] = subject
            msg.attach(m_text)

            with SMTP_SSL(smtp_server, port, context=context) as server:
                server.login("bar.summarization@gmail.com", password)
                server.sendmail(sender_email, recipient, msg.as_string())
