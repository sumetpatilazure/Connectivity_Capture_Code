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


############################################################################################################################################################################################################################################

# import socket
# import threading
# import time
# import datetime
# from datetime import timezone
#
# ipaddress = socket.gethostbyname(socket.gethostname())
# port = 50000
# socket_address = (ipaddress, port)
# Format = "utf-8"
# client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Header = 64
#
# client_socket.connect(socket_address)
#
#
# def send():
#     try:
#         while True:
#             msg = input("ENTER THE MESSAGE THAT YOU WANT TO SEND TO SERVER: ")  # msg in string format
#             if msg != "!DISCONNECT":
#                 msg = msg.encode(Format)  # encode the message in byte format
#                 # print(f"This is how the msg looks in byte format {msg}")
#
#                 msg_length = len(msg)
#                 # print(f"This is the length of the msg in byte format {msg_length}")
#
#                 send_length = str(msg_length).encode(Format)
#                 # print(f"This is how the send_length parameter looks {send_length} in byte format")
#
#                 # send_length += b' ' * (Header - len(send_length))
#
#                 client_socket.send(send_length)
#                 client_socket.send(msg)
#                 server_response = client_socket.recv(2048).decode(Format)
#                 print(f"SERVER RESPONSE: {server_response}")
#             else:
#                 client_socket.close()
#                 break
#     except KeyboardInterrupt:
#         print("Forcibly closed")
#
#
# send()

############################################################################################################################################################################################################################################
# import socket
# import threading
#
# server_ip = socket.gethostbyname(socket.gethostname())
# port = 50000
# HEADER = 64
# FORMAT = "utf-8"
# server_conn = (server_ip, port)
# client_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#
#
# def send():
#     try:
#         client_sock.connect(server_conn)
#         while True:
#             client_msg = input("Enter the msg: ")
#             if client_msg != "DISCONNECT":
#                 client_msg = client_msg.encode(FORMAT)
#                 msg_length = len(client_msg)
#                 send_msg_length = str(msg_length).encode(FORMAT)
#                 send_msg_length += b' ' * (HEADER - len(send_msg_length))
#
#                 client_sock.send(send_msg_length)
#                 client_sock.send(client_msg)
#                 print("msg to be decoded")
#                 server_msg = client_sock.recv(2048).decode(FORMAT)
#                 print("msg decoded")
#                 print(f"SERVER MSG RECEIVED: {server_msg}")
#
#             else:
#                 client_sock.close()
#                 break
#
#     except KeyboardInterrupt:
#         print("closed the connection forcefully")
#
#
# send()
