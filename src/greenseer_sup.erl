
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
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  Dispatch = [{'_', [
    {'_', websocket_handler, []}
  ]}],

  Receiver = {greenseer_receiver,
              {greenseer_receiver, start_link, []},
              permanent, 5000, worker, [greenseer_receiver]},

  Cowboy = cowboy:child_spec(greenseer_cowboy, 100, cowboy_ssl_transport,
                             [{port, 8443}, {certfile, "priv/ssl/cert.pem"},
                              {keyfile, "priv/ssl/key.pem"}, {password, "cowboy"}],
                             cowboy_http_protocol, [{dispatch, Dispatch}]),

  {ok, { {one_for_one, 10000, 10}, [Receiver, Cowboy]} }.
