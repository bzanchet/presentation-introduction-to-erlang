-module(chat_client).

-export([register_nick/2, start/0, send_message/3]).

start() ->
    spawn(fun() -> receive_messages() end).

register_nick(ClientPid, Nick) ->
    ClientPid ! {register_nick, Nick}.

send_message(ClientPid, Addressee, MessageBody) ->
    ClientPid ! {send_message, Addressee, MessageBody}.

receive_messages() ->
    receive
    	{receive_message, From, MessageBody} ->
    	    io:format("[~p] Received from [~p]: ~p~n", [self(), From, MessageBody]),
    	    receive_messages();
    	{register_nick, Nick} ->
            router:register_nick(Nick, self()),
    	    receive_messages();
    	{send_message, Addressee, MessageBody} ->
            router:send_chat_message(self(), Addressee, MessageBody),
    	    receive_messages();
    	shutdown ->
    	    io:format("/quit is this irc yet?~n");
    	Bullshit ->
    	    io:format("Client warning! Received: ~p~n", [Bullshit]),
    	    receive_messages()
    end.    
