-module(chat_client).

-export([start/1, send_message/3]).

start(RouterPid) ->
    spawn(fun() -> receive_messages(RouterPid) end).

send_message(ClientPid, Addressee, MessageBody) ->
    ClientPid ! {send_message, Addressee, MessageBody}.

receive_messages(RouterPid) ->
    receive
    	{send_message, Addressee, MessageBody} ->
            router:send_chat_message(RouterPid, self(), Addressee, MessageBody),
    	    receive_messages(RouterPid);
    	{receive_message, From, MessageBody} ->
    	    io:format("[~p] Received from [~p]: ~p~n", [self(), From, MessageBody]),
    	    receive_messages(RouterPid);
    	shutdown ->
    	    io:format("/quit is this irc yet?~n");
    	Bullshit ->
    	    io:format("Client warning! Received: ~p~n", [Bullshit]),
    	    receive_messages(RouterPid)
    end.    
