-module(greenseer_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
  application:start(greenseer).

% %% Use a static list of content types.

start(_StartType, _StartArgs) ->
  io:fwrite(">> START"),
  greenseer_websocket_server:start(),
  greenseer_sup:start_link().

stop(_State) ->
    ok.
