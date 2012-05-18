-module(greenseer_server).
-behaviour(gen_server).

-export([start_link/0]).

%% Application callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-record(state, {}).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ===================================================================
%% Application callbacks
%% ===================================================================

init([]) ->
  {ok, Listen} = gen_tcp:listen(1234, [{packet,0},
                                    {reuseaddr,true},
                                    {active, true}]),
  gen_tcp:accept(Listen),
  {ok, #state{}}.

handle_call(_Request, _From, State) ->
  {noreply, ok, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(Msg, State) ->
  io:fwrite("~p~n", [Msg]),
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
