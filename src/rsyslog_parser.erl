-module(rsyslog_parser).
-compile([export_all]).
-export([parse/1, syslog_to_json/1]).

syslog_to_json(Log) ->
  {ok, ParsedLog} = parse(Log),
  jiffy:encode({ParsedLog}).

parse(Log) ->
  {Priority, ParsedLog} = parse_priority(Log),
  [Month, Day, Time|SplitMessage] = string:tokens(ParsedLog, " "),

  Timestamp = string:join([Month, Day, Time], " "),
  Message = string:join(SplitMessage, " "),

  {ok, [{priority, Priority}, {timestamp, list_to_binary(Timestamp)}, {message, list_to_binary(Message)}]}.

parse_priority(Log) ->
  SplitAt = string:rchr(Log, $>),
  {RawPriority, ParsedLog} = lists:split(SplitAt, Log),
  Priority = list_to_integer(re:replace(RawPriority, "[<|>]", "", [global, {return, list}])),

  {Priority, ParsedLog}.
