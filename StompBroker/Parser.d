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
		string[] toParse = message.splitLines();
		Message parsedMessage;
		//The first line will always be the action of the message (IE: SUBSCRIBE, SEND)
		parsedMessage.Header = toParse[0];
		parsedMessage.Header = parsedMessage.Header.toLower();
		//Need to use a for as opposed to a foreach to skip the first iteration
		for(int i = 1; i < toParse.length; i++){
			string[] line = toParse[i].split(':');
			if(line[0] == "^@"){
				break;
			}
			if(line.length > 1){
				line[0] = line[0].toLower();
				line[1] = line[1].toLower();
				line[0] = line[0].removechars(" ");
				line[1] = line[1].removechars(" ");
				parsedMessage.Options[line[0]] = line[1];
			}
			else if (line.length <= 1){
				parsedMessage.Body ~= line[0];}
		}
		return parsedMessage;
	}

	public static string[] ParseChannels(string channels){
		string[] toChannels = channels.split("\\");
		return toChannels;
	}

	public static string FormatMessage(Message message){
		string formattedMessage;
		formattedMessage ~= message.Header ~ "\n";
		foreach(string key; message.Options.byKey){
			formattedMessage ~= key ~ ":" ~ message.Options[key];
		}
		formattedMessage ~= "^@";
		return formattedMessage;
	}
}

