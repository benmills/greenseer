-module(rsyslog_parser_test).
-compile([export_all]).

-include_lib("include/log.hrl").
-include_lib("eunit/include/eunit.hrl").

simple_parse_test() ->
  Log = rsyslog_parser:parse("<13>May 1 13:00:25 localhost benmills: foo"),

  ?assertEqual(<<"localhost">>, Log#log.host),
  ?assertEqual(<<"benmills">>, Log#log.programname),
  ?assertEqual(13, Log#log.priority),
  ?assertEqual(<<"May 1 13:00:25">>, Log#log.timestamp),
  ?assertEqual(<<"foo">>, Log#log.message).

complex_parse_test() ->
  Log = rsyslog_parser:parse("<3>Jun 1 13:00:25 localhost benmills: foo bar baz"),

  ?assertEqual(3, Log#log.priority),
  ?assertEqual(<<"localhost">>, Log#log.host),
  ?assertEqual(<<"benmills">>, Log#log.programname),
  ?assertEqual(<<"Jun 1 13:00:25">>, Log#log.timestamp),
  ?assertEqual(<<"foo bar baz">>, Log#log.message).

json_test() ->
  Json = rsyslog_parser:syslog_to_json("<3>Jun 1 13:00:25 localhost benmills: foo bar baz"),
  io:fwrite("~p~n", [Json]),
  Expected = <<"{\"priority\":3,\"host\":\"localhost\",\"programname\":\"benmills\",\"timestamp\":\"Jun 1 13:00:25\",\"message\":\"foo bar baz\"}">>,

  ?assertEqual(Expected, Json).
