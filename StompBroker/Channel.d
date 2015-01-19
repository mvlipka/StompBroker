module Channel;
import std.container;
import std.algorithm;
import std.stdio;
import std.socket;
import Client;
import parser;

public static shared Channel[string] CHANNELS;

//public void addChannel(string channel){
//	string[] channels = parser.Parser.ParseChannels(channel);
//	foreach(string chan; channels){
//		CHANNELS[
//	}
//}
synchronized class Channel
{
	string name;
	shared int[shared Client] subscribedClients;
	uint uid = 0;
	this(string name)
	{
		this.name = name;
	}

	public void Subscribe(shared Client client){
		subscribedClients[client] = this.uid;
		this.uid++;
		client.Subscribe(this.name);
		//Client temp = cast(Client)client;
		//writeln(temp.toString() ~ " has subscribed to channel " ~ (cast(Channel)this).toString());
	}

	public void Unsubscribe(shared Client client){
		this.subscribedClients.remove(client);
		//writeln((cast(Client)client).toString(), " has unsubscribed to channel ", (cast(Channel)this).toString());
	}

	public void Send(shared string message){
		foreach(shared Client client; subscribedClients.byKey()){
			(cast(Socket)client.socket).send(message);
			client.SendToClient(message);
		}
	}

	public string toString() shared {
		return name;
	}
}

