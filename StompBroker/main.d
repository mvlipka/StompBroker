module main;

import std.stdio;
import std.socket;
import std.concurrency;
import std.file;
import std.utf;
import std.uuid;

import Client;
import Channel;
import parser;

void handleClient(shared Client sharedClient){
	//Hack to allow the STL to be used on a shared object
	shared Client client = cast(shared Client)sharedClient;
	char[1024] buf;
	while(true){
		//Lock the memory in-case multiple channels want to access the client
		synchronized{
			auto received = (cast(Client)client).socket.receive(buf);
			if(received > 0){
				parser.Message message = parser.Parser.Parse(buf[0 .. received]);
				writeln(message);
				//writeln(message);
				//All of the message has been formatted to be lower-case and to have no whitespace
				if(message.Header == "connect"){
					parser.Message toClientMessage;
					toClientMessage.Header = "CONNECTED";
					toClientMessage.Options["session"] = randomUUID().toString();
					client.SendToClient(parser.Parser.FormatMessage(toClientMessage));
				}
				else if(message.Header == "disconnect"){
					foreach(string chan; client.subscribedChannels){
						CHANNELS[chan].Unsubscribe(client);
					}
					delete client;
					goto EXITLOOP;
				}
				else if(message.Header == "subscribe"){
					if(!(message.Options["destination"] in CHANNELS)){
						shared Channel temp = new shared Channel(message.Options["destination"]);
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
				else if(message.Header == "send"){
					parser.Message toClientMessage;
					toClientMessage.Header = "MESSAGE";
					toClientMessage.Options["destination"] = message.Options["destination"];
					toClientMessage.Options["message-id"] = randomUUID().toString();
					toClientMessage.Body = message.Body;
					CHANNELS[message.Options["destination"]].SendToClients(parser.Parser.FormatMessage(toClientMessage));
				}
			}
		}
	}
	EXITLOOP:
	writeln("Client thread ending...");
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

