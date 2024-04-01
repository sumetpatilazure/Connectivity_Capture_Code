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


########################################################################################################################################################################################################################################################

# import socket
# import threading
# import time
# import datetime
# from datetime import timezone
#
# Header = 64
# Format = "utf-8"
#
# ipaddress = socket.gethostbyname(socket.gethostname())
# port = 50000
#
# socket_address = (ipaddress, port)
# server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#
# server_socket.bind(socket_address)
#
#
# def handle_client_connection(client_conn, client_address):
#     print(f"[NEW CONNECTION FROM {client_address}]")
#     connected = True
#     while connected:
#         msg_length = client_conn.recv(Header).decode(Format)
#         # Converted from Bytes to String. Expecting 64 bytes of data to be received
#         if msg_length:
#             msg_length = int(msg_length)  # String to integer
#             client_msg = client_conn.recv(msg_length).decode(Format)
#
#             if client_msg == "!DISCONNECT":
#                 connected = False
#
#             print(f"[CLIENT'S MESSAGE RECEIVED from {client_address} IS: ] {client_msg}")
#             msg_to_server = "Message received thanks!"
#             msg_to_server = msg_to_server.encode(Format)
#             client_conn.send(msg_to_server)
#     client_conn.close()
#
#
# def start():
#     while True:
#         server_socket.listen()
#         print(f"[SERVER LISTENING ON {socket_address}]")
#         client_conn, client_address = server_socket.accept()
#         print(f"[SERVER ACCEPTED CONNECTION ON {socket_address}]")
#         thread = threading.Thread(target=handle_client_connection, args=(client_conn, client_address))
#         thread.start()
#         print(f"[ACTIVE CONNECTION] {threading.active_count() - 1}")
#
#
# print(f"[STARTING] server is starting...")
#
# start()


########################################################################################################################################################################################################################################################

# import socket
# import threading
#
# server_ip = socket.gethostbyname(socket.gethostname())
# port = 50000
# HEADER = 64
# FORMAT = "utf-8"
# server_conn = (server_ip, port)
# server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#
# server_sock.bind(server_conn)
#
#
# def client_handle(client_conn, client_ip):
#     Connected = True
#     print(f"[CONNECTION SUCCESSFUL WITH] {client_ip}")
#     while Connected:
#         msg_length = client_conn.recv(HEADER).decode(FORMAT)
#         if msg_length:
#             msg_length = int(msg_length)
#             msg = client_conn.recv(msg_length).decode(FORMAT)
#             if msg == "!DISCONNECT":
#                 Connected = False
#             print(f"{msg} received from {client_ip}")
#             print("SENDING RESPONSE BACK TO CLIENT")
#             client_msg_to_server = "Msg received"
#             client_msg_to_server = client_msg_to_server.encode(FORMAT)
#             client_conn.send(client_msg_to_server)
#     client_conn.close()
#
#
# def start():
#     while True:
#         server_sock.listen()
#         print(f"[SERVER IS LISTENING] on {server_ip}")
#         client_conn, client_ip = server_sock.accept()
#         thread = threading.Thread(target=client_handle, args=(client_conn, client_ip))
#         thread.start()
#         print(f"NUMBER OF ACTIVE CONNECTIONS: {threading.active_count() - 1}")
#
#
# print("SERVER STARTED...")
# start()
