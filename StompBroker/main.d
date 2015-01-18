module main;

import std.stdio;
import std.socket;
import std.concurrency;
import std.file;

import Client;


void handleClient(shared Client sharedClient){
	writeln("started");
	Client client = cast(Client)sharedClient;
	char[1024] buf;
	while(true){
		while(client.socket.receive(buf) > 0){
			writeln(buf);
		}
	}
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
		auto clientThread  = spawn(&handleClient, client);
		send(clientThread, client);
	}
}

