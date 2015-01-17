module Client;
import std.socket;
import std.stdio;
synchronized class Client
{
	Socket * socket;
	this(shared Socket * sock) shared
	{
		this.socket = sock;
	}
}

