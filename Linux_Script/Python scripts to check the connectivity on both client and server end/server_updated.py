# Importing the required modules
import socket
import threading
import time
import datetime
from datetime import timezone

#Pull up the ip address information from your machine if you are running the client and server app on the same machine
# setting up the port number and creating a server socket to listen to the connection from the server
ipaddress = socket.gethostbyname(socket.gethostname())
port = 50000
socket_address = (ipaddress, port)

# Repeating the below behavior to listen for the multiple TCP source port coming from the source end and to check connectivity on those ports
while True:
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 				 # creating server socket
    server_socket.bind(socket_address) 								 # binding the server address and the port to the socket
    server_socket.listen()									 # server listening on the port for the client connection
    print(f"[SERVER LISTENING ON ] {socket_address}")
    client_conn_socket, client_address = server_socket.accept()         			 # gathering the client socket and address info once it accepts the connection from the client end
    print(datetime.datetime.now(timezone.utc))                         				 # Makinf not of the time the connection happened
    print(f"[SERVER ACCEPTED THE CONNECTION FROM THE CLIENT COMING FROM]  {client_address}")
    msg = "TCP CONNECTION ESTABLISHED WITH THE SERVER ON " + ipaddress				
    encoded_msg = msg.encode("utf-8")								 # Encoding the message in the utf-8 format
    client_conn_socket.send(encoded_msg)							 # sending the message back to the client that server accepted the connection
    client_conn_socket.close()									 # closing the client connection from the server end	
    server_socket.close()									 # server closing its connection 
    time.sleep(1)										 # Waiting for 1 second interval before the process is repeated	
