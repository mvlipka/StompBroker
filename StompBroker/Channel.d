module Channel;
import std.container;
import std.algorithm;
import std.stdio;
import Client;
import parser;

public static Channel[string] CHANNELS;

//public void addChannel(string channel){
//	string[] channels = parser.Parser.ParseChannels(channel);
//	foreach(string chan; channels){
//		CHANNELS[
//	}
//}
class Channel
{
	string name;
	int[Client] subscribedClients;
	uint uid = 0;
	this(string name)
	{
		this.name = name;
	}

	public void Subscribe(Client client){
		subscribedClients[client] = uid;
		uid++;
		writeln(client, " has subscribed to channel ", this);
	}

	public void Unsubscribe(Client client){
		subscribedClients.remove(client);
		writeln(client, " has unsubscribed to channel ", this);
	}

	public void Send(string message){
		foreach(Client client; subscribedClients.byKey()){
			client.socket.send(message);
		}
	}

	public override string toString() {
		return name;
	}
}

