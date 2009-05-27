-module(local_router).

-compile(export_all).

start() ->
    spawn(local_router, route_messages, []).

stop(RouterPid) ->
    RouterPid ! shutdown.

send_chat_message(RouterPid, From, Addressee, MessageBody) ->
    RouterPid ! {dispatch_chat_message, From, Addressee, MessageBody}.

route_messages() ->
    receive
    	{dispatch_chat_message, From, Addressee, MessageBody} ->
    	    Addressee ! {receive_message, From, MessageBody},
    	    route_messages();
    	shutdown ->
    	    io:format("Shutting down~n");
    	Oops ->
    	    io:format("Warning! Received: ~p~n", [Oops]),
    	    route_messages()
    end.
