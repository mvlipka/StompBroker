module parser;
import std.string;
import std.stdio;
struct Message{
	string Header;
	string[string] Options;
	string Body;
}
synchronized class Parser
{
	public static Message Parse(char[] message){
		message = message.toLower();
		message.removechars(" ");
		string[] toParse = message.splitLines();
		Message parsedMessage;
		//The first line will always be the action of the message (IE: SUBSCRIBE, SEND)
		parsedMessage.Header = toParse[0];
		//Need to use a for as opposed to a foreach to skip the first iteration
		for(int i = 1; i < toParse.length; i++){
			string[] line = toParse[i].split(':');
			if(line[0] == "^@"){ break; }
			if(line.length > 0){
				parsedMessage.Options[line[0]] = line[1];
			}
			else{ parsedMessage.Body = line[0];}
		}
		return parsedMessage;
	}

	public static string[] ParseChannels(string channels){
		string[] toChannels = channels.split("\\");
		return toChannels;
	}
}

