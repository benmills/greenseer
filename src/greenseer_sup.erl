
-module(greenseer_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).


%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    io:fwrite(">> Start Sup"),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  Children = [
    {greenseer_receiver,
      {greenseer_receiver, start_link, []},
      permanent, 5000, worker, [greenseer_receiver]}
  ],
  {ok, { {one_for_one, 10000, 10}, Children} }.
