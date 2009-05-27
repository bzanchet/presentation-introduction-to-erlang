-module(chat_client).

-compile(start/0, send_message/3).

start() ->
    spawn(fun() -> chat_client:receive_messages([]) end).

send_message(ClientPid, Addressee, MessageBody) ->
    ClientPid ! {send_message, Addressee, MessageBody}.

receive_messages() ->
    receive
    	{send_message, Addressee, MessageBody} ->
            message_router:send_chat_message(self(), Addressee, MessageBody),
    	    receive_messages();
    	{receive_message, From, MessageBody} ->
    	    io:format("[~p] Received from [~p]: ~p~n", [self(), From, MessageBody]),
    	    receive_messages();
    	shutdown ->
    	    io:format("/quit is this irc yet?~n");
    	Bullshit ->
    	    io:format("Client warning! Received: ~p~n", [Bullshit]),
    	    receive_messages()
    end.    
