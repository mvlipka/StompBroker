module Client;
import std.socket;
import std.stdio;

import Channel;
synchronized class Client
{
	Socket socket;
	string[] subscribedChannels;
	this(shared Socket sock)
	{
		this.socket = sock;
	}

	public void Subscribe(string channel) {
		subscribedChannels ~= channel;
	}

	public void SendToChannel(string channel, string message){
		CHANNELS[channel].Send(message);
	}

	public void SendToClient(string message){
		this.socket.send(message); 
	}
}

