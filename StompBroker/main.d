module main;

import std.stdio;
import std.socket;
import std.concurrency;

import Client;

void handleClient(){
	writeln("started");
	receive(
		(shared Client client) {
			writefln("HI");
			while(true){
				char[1024] buf;
				auto message = client.socket.receive(buf);
				writeln(message);
			}
		}
		);
	writefln("done");
}

void main(string[] args)
{
	writeln("Starting Server...");
	TcpSocket serverSocket = new TcpSocket(AddressFamily.INET);
	serverSocket.bind(new InternetAddress(1999));
	serverSocket.listen(5);
	writeln("Server is listning on port: ", serverSocket.localAddress.toPortString());
	while(true){
		Socket clientSocket = serverSocket.accept();
		writeln("Connected: ", clientSocket.remoteAddress);
		shared Client client = new shared Client(cast(shared)clientSocket);
		auto clientThread  = spawn(&handleClient);
		send(clientThread, client);
	}
}

