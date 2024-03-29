-module(greenseer_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
  application:start(sasl),
  application:start(crypto),
  application:start(public_key),
  application:start(ssl),
  application:start(gproc),
  application:start(cowboy),
  application:start(greenseer).

% %% Use a static list of content types.

start(_StartType, _StartArgs) ->
  greenseer_sup:start_link().

stop(_State) ->
    ok.
