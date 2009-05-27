-module(router).

-define(SERVER, router).

-compile(export_all).

start() ->
    global:trans({?SERVER, ?SERVER},
		 fun() ->
			 case global:whereis_name(?SERVER) of
			     undefined ->
				     Pid = spawn(router, route_messages, [dict:new()]),
				 global:register_name(?SERVER, Pid);
			        _ ->
				 ok
			 end
		 end).

send_chat_message(From, Addressee, MessageBody) ->
    global:send(?SERVER, {dispatch_chat_message, From, Addressee, MessageBody}).

register_nick(ClientName, Pid) ->
    global:send(?SERVER, {register_nick, ClientName, Pid}).

route_messages(Clients) ->
    receive
    	{dispatch_chat_message, From, ClientName, MessageBody} ->
    	    case dict:find(ClientName, Clients) of
        		{ok, Pid} ->
        		    Pid ! {receive_message, From, MessageBody};
        		error ->
        		    io:format("Unknown client ~p~n", ClientName)
        	    end,
    	    route_messages(Clients);
    	{register_nick, ClientName, Pid} ->
    	    route_messages(dict:store(ClientName, Pid, Clients));
    	shutdown ->
    	    io:format("Shutting down~n");
    	Oops ->
    	    io:format("Warning! Received: ~p~n", [Oops]),
    	    route_messages(Clients)
    end.
