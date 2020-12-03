from cryptography.fernet import Fernet
key = Fernet.generate_key()
print(key)
cipher_suite = Fernet(key)
ciphered_text = cipher_suite.encrypt(b'3aecba319fbc4f708653d06f7a44b69d')
with open('c:\savedfiles\mssqltip_bytes.bin', 'wb') as file_object:  file_object.write(ciphered_text)

