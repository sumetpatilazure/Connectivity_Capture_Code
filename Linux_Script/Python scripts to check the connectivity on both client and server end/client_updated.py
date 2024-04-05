# Importing the required modules
import socket
import threading
import time


#Pull up the ip address information from your machine if you are running the client and server app on the same machine
# ipaddress = socket.gethostbyname(socket.gethostname())

# Get the required information of the server to initiate the connection to it after creating a client socket 
ipaddress = input("Enter the server IP address that you want to connect to: ")
port = 50000
socket_address = (ipaddress, port)

# Repeating the below behavior to create multiple TCP streams to check connectivity on multiple ports
while True:
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # creating client socket
    client_socket.connect(socket_address) # initiating the connection to the server socket
    received_msg = client_socket.recv(2048).decode("utf-8") #receving the response from the server and decoding the response in the string format
    print(f"TCP RESPONSE MESSAGE RECEIVED FROM THE {socket_address} is {received_msg}")
    client_socket.close() # closing the connection
