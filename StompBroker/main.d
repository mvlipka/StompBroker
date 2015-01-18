module main;

import std.stdio;
import std.socket;
import std.concurrency;
import std.file;

import Client;
import Channel;
import parser;

void handleClient(shared Client sharedClient){
	//Hack to allow the STL to be used on a shared object
	Client client = cast(Client)sharedClient;
	while(true){
		//Lock the memory in-case multiple channels want to access the client
		synchronized{
			char[1024] buf;
//			while(client.socket.receive(buf) > 0){
//				parser.Message message = Parser.Parse(cast(string)buf);
//				writeln(message);
//			}
			if(client.socket.receive(buf) > 0){
				writeln(buf.dup.toLower());
			}
		}
	}
}
import std.string;
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

