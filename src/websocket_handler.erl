-module(websocket_handler).
-behaviour(cowboy_http_handler).
-behaviour(cowboy_http_websocket_handler).

-export([broadcast/1]).

%% Application callbacks
-export([init/3, handle/2, handle_info/2, terminate/2]).

%% Websockets callbacks
-export([websocket_init/3, websocket_handle/3,
  websocket_info/3, websocket_terminate/3]).

broadcast(Msg) ->
  gproc:send({p, l, {?MODULE, braintree}}, {self(), {?MODULE, braintree}, Msg}).

%% ===================================================================
%% Application callbacks
%% ===================================================================

init({_Any, http}, Req, []) ->
  case cowboy_http_req:header('Upgrade', Req) of
    {undefined, Req2} -> {ok, Req2, undefined};
    {<<"websocket">>, _Req2} -> {upgrade, protocol, cowboy_http_websocket};
    {<<"WebSocket">>, _Req2} -> {upgrade, protocol, cowboy_http_websocket}
  end.

handle_info(_, State) ->
  {noreply, State}.

handle(Req, State) ->
  {ok, Req2} = cowboy_http_req:reply(200, [{'Content-Type', <<"text/html">>}], <<"OK">>, Req),
  {ok, Req2, State}.

terminate(_Req, _State) ->
  ok.

%% ===================================================================
%% Websockets callbacks
%% ===================================================================

websocket_init(_Any, Req, []) ->
  gproc:reg({p, l,{?MODULE, braintree}}),
  Res = cowboy_http_req:compact(Req),
  {ok, Res, undefined, hibernate}.

websocket_handle(_Any, Req, State) ->
  {ok, Req, State}.

websocket_info({_Pid, {_Module, braintree}, Msg}, Req, State) ->
  {reply, {text, Msg}, Req, State, hibernate};
websocket_info(_Info, Req, State) ->
  {ok, Req, State, hibernate}.

websocket_terminate(_Reason, _Req, _State) ->
  ok.
