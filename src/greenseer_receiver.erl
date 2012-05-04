-module(greenseer_receiver).
-behaviour(gen_server).

-export([register_client/1, start_link/0]).

%% Application callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-record(state, {clients}).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

register_client(Client) ->
  io:fwrite("REGISETER"),
  gen_server:call(?MODULE, {register, Client}).

%% ===================================================================
%% Application callbacks
%% ===================================================================

init([]) ->
  {ok, _Socket} = gen_udp:open(1337),
  {ok, #state{clients = []}}.

handle_call({register, Client}, _From, #state{clients=Clients}) ->
  {reply, ok, #state{clients = Clients ++ [Client]}};
handle_call(_Request, _From, State) ->
  {noreply, ok, State}.

handle_cast(Msg, State) ->
  {noreply, State}.

handle_info({udp, _Port, _Host, _, Msg}, State) ->
  Log = rsyslog_parser:syslog_to_json(Msg),
  websocket_handler:broadcast(Log),
  {noreply, State};
handle_info(Msg, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
