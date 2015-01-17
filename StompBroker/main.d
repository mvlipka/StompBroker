module main;

import std.stdio;
import std.socket;
import std.concurrency;

import Client;

void handleClient(shared Client * client){
	char[1024] buf;
	auto message = client.receive(buf);
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
		writeln(clientSocket.remoteAddress);
		shared Client client = new shared Client(cast(shared)clientSocket);
		spawn(&handleClient, client);
	}
}

