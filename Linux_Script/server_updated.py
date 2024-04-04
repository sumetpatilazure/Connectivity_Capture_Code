import socket
import threading
import time
import datetime
from datetime import timezone

ipaddress = socket.gethostbyname(socket.gethostname())
port = 50000
socket_address = (ipaddress, port)

while True:
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(socket_address)
    server_socket.listen()
    print(f"[SERVER LISTENING ON ] {socket_address}")
    client_conn_socket, client_address = server_socket.accept()
    print(datetime.datetime.now(timezone.utc))
    print(f"[SERVER ACCEPTED THE CONNECTION FROM THE CLIENT COMING FROM]  {client_address}")
    msg = "TCP CONNECTION ESTABLISHED WITH THE SERVER ON " + ipaddress
    encoded_msg = msg.encode("utf-8")
    client_conn_socket.send(encoded_msg)
    client_conn_socket.close()
    server_socket.close()
    time.sleep(1)
