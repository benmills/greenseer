-module(rsyslog_parser).
-compile([export_all]).
-export([parse/1, syslog_to_json/1]).

-include_lib("include/log.hrl").

syslog_to_json(Log) ->
  ParsedLog = parse(Log),
  jiffy:encode({[{priority, ParsedLog#log.priority},
                 {host, ParsedLog#log.host},
                 {programname, ParsedLog#log.programname},
                 {timestamp, ParsedLog#log.timestamp},
                 {message, ParsedLog#log.message}]}).

parse(Log) ->
  {Priority, ParsedLog} = parse_priority(Log),
  [Month, Day, Time|SplitMessage] = string:tokens(ParsedLog, " "),
  Timestamp = string:join([Month, Day, Time], " "),
  {Host, ProgramName, Message} = parse_split_message(SplitMessage),

  #log{priority = Priority,
       host = list_to_binary(Host),
       timestamp = list_to_binary(Timestamp),
       programname = list_to_binary(ProgramName),
       message = list_to_binary(Message)}.

parse_priority(Log) ->
  SplitAt = string:rchr(Log, $>),
  {RawPriority, ParsedLog} = lists:split(SplitAt, Log),
  Priority = list_to_integer(re:replace(RawPriority, "[<|>]", "", [global, {return, list}])),

  {Priority, ParsedLog}.

parse_split_message([Host, ProgramName|SplitMessage]) ->
  {Host, re:replace(ProgramName, ":", "", [{return, list}]), string:join(SplitMessage, " ")}.
