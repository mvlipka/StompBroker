module Channel;
import std.container;
import std.algorithm;
import std.stdio;
import Client;
class Channel
{
	int[Client] subscribedClients;
	uint uid = 0;
	this()
	{
	}

	public void Subscribe(Client client){
		subscribedClients[client] = uid;
		uid++;
	}

	public void Unsubscribe(Client client){
		subscribedClients.remove(client);
	}

	public void Send(string message){
		foreach(Client client; subscribedClients.byKey()){
			client.socket.send(message);
		}
	}
}

