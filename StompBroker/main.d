module main;

import std.stdio;
import std.socket;
import std.concurrency;
import std.file;
import std.utf;

import Client;
import Channel;
import parser;

void handleClient(shared Client sharedClient){
	//Hack to allow the STL to be used on a shared object
	Client client = cast(Client)sharedClient;
	char[1024] buf;
	while(true){
		//Lock the memory in-case multiple channels want to access the client
		synchronized{
			auto received = client.socket.receive(buf);
			if(received > 0){
				parser.Message message = parser.Parser.Parse(buf[0 .. received]);
				writeln(message);
				if(message.Header == "subscribe"){
					if(!(message.Options["destination"] in CHANNELS)){
						Channel temp = new Channel(message.Options["destination"]);
						temp.Subscribe(client);
						//temp.Send("TEMP");
						CHANNELS[message.Options["destination"]] = temp;
					}
				}
				else if(message.Header == "unsubscribe"){
					if(message.Options["destination"] in CHANNELS){
						CHANNELS[message.Options["destination"]].Unsubscribe(client);
						//CHANNELS[message.Options["destination"]].Send("RJWA");
					}
				}
			}
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

