import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("127.0.0.1", 1999))


message = "CONNECT\n"
message += "login: mvlipka\n"
message += "passcode: lipka\n"
message += "^@"
s.send(bytes(message, 'UTF-8'));
message = s.recv(1024)
print(message)


message = "SUBSCRIBE\n"
message += "destination: /mychannel\n"
message += "ack:client\n"
message += "^@"
s.send(bytes(message, 'UTF-8'))


message = "SEND\n"
message += "destination: /mychannel\n"
message += "HEY EVERYONE\n"
message += "^@"
s.send(bytes(message, 'UTF-8'))
message = s.recv(1024)
print(message)


message = "UNSUBSCRIBE\n"
message += "destination: /mychannel\n"
message += "^@"
s.send(bytes(message, 'UTF-8'))


message = "DISCONNECT\n"
message += "^@"
s.send(bytes(message, 'UTF-8'))

s.close()