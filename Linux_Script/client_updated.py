import socket
import threading
import time

ipaddress = socket.gethostbyname(socket.gethostname())
port = 50000
socket_address = (ipaddress, port)

while True:
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.connect(socket_address)
    received_msg = client_socket.recv(2048).decode("utf-8")
    print(f"TCP RESPONSE MESSAGE RECEIVED FROM THE {socket_address} is {received_msg}")
    client_socket.close()
