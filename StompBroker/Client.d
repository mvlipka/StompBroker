module Client;
import std.socket;
import std.stdio;

import parser;
import Channel;

synchronized class Client
{
	Socket socket;
	string[] subscribedChannels;
	this(shared Socket sock)
	{
		this.socket = sock;
	}

	public void Subscribe(shared string channel) {
		subscribedChannels ~= channel;
	}

	public void SendToChannel(shared string channel, shared string message){
		CHANNELS[channel].Send(message);
	}

	public void SendToClient(shared string message){
		(cast(Socket)this.socket).send(message);
	}

	public string toString(){
		string temp = (cast(Socket)this.socket).remoteAddress.toString();
		return temp;
	}
}

