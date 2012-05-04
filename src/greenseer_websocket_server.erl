-module(greenseer_websocket_server).

-export([start/0]).

start() ->
  io:fwrite(">>> starting cowboys"),

  Dispatch = [{'_', [
    {[<<"static">>, '...'], cowboy_http_static,
      [
        {directory, <<"./priv">>},
        {mimetypes, [
          {<<".html">>, [<<"text/html">>]},
          {<<".css">>, [<<"text/css">>]},
          {<<".js">>, [<<"application/javascript">>]}
        ]}
      ]},

    {'_', websocket_handler, []}
  ]}],

  cowboy:start_listener(my_http_listener, 100,
    cowboy_tcp_transport, [{port, 8080}],
    cowboy_http_protocol, [{dispatch, Dispatch}]
  ).
