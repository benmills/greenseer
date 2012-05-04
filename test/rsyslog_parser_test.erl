-module(rsyslog_parser_test).
-compile([export_all]).

-include_lib("eunit/include/eunit.hrl").

simple_parse_test() ->
  {ok, [{priority, Prioirty}, {timestamp, Timestamp}, {message, Message}]} = rsyslog_parser:parse("<13>May 1 13:00:25 localhost benmills: foo"),

  ?assertEqual(13, Prioirty),
  ?assertEqual(<<"May 1 13:00:25">>, Timestamp),
  ?assertEqual(<<"localhost benmills: foo">>, Message).

complex_parse_test() ->
  {ok, [{priority, Prioirty}, {timestamp, Timestamp}, {message, Message}]} = rsyslog_parser:parse("<3>Jun 1 13:00:25 localhost benmills: foo bar baz"),

  ?assertEqual(3, Prioirty),
  ?assertEqual(<<"Jun 1 13:00:25">>, Timestamp),
  ?assertEqual(<<"localhost benmills: foo bar baz">>, Message).
