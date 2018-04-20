%%%****************************************************************************
%%% Common tests for basic_api functionality
%%%
%%% @copyright 2018 Tumdash
%%%****************************************************************************
-module(basic_api_SUITE).
-author('nickolay.kovalev@gmail.com').

%% common tests mandatories
-export([all/0, groups/0, suite/0]).
-export([init_per_suite/1, end_per_suite/1]).
-export([init_per_group/2, end_per_group/2]).
-export([init_per_testcase/2, end_per_testcase/2]).

%% testsuites list or export_all
-export([
    get_api/1, post_api/1, put_api/1, delete_api/1
]).
%-compile(export_all).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

%%%****************************************************************************
%%% Common Test API
%%%****************************************************************************
suite() ->
    [
        {timetrap, {seconds, 120}}
    ].

all() ->
    [
        {group, api}
    ].


groups() ->
    [
        {api, [], api_tests()}
    ].

api_tests() ->
    [
        get_api,
        post_api,
        put_api,
        delete_api
    ].

init_per_suite(Config) ->
    {ok, _} = application:ensure_all_started(mikbodo),
    Config.

end_per_suite(_Config) ->
    ok.

init_per_group(_Group, Config) ->
    Config.

end_per_group(_Group, _Config) ->
    ok.

init_per_testcase(_Name, Config) ->
    Config.

end_per_testcase(_Name, _Config) ->
    ok.

%%%****************************************************************************
%%% TESTCASES
%%%****************************************************************************
get_api(_Config) ->
    {ok, {Status, Headers, Body}} =
        httpc:request("http://localhost:8080/mikbodo"),
    ?assertEqual("Get Successful!", Body),
    ?assert(is_list(Headers)),
    ?assertMatch({"HTTP/1.1",200,"OK"}, Status).

post_api(_Config) ->
    {ok, {Status, Headers, Body}} =
        httpc:request(post, {"http://localhost:8080/mikbodo", [], "application/text", <<>>}, [], []),
    ?assertEqual("Post Successful!", Body),
    ?assert(is_list(Headers)),
    ?assertMatch({"HTTP/1.1",200,"OK"}, Status).

put_api(_Config) ->
    {ok, {Status, Headers, Body}} =
        httpc:request(put, {"http://localhost:8080/mikbodo", [], "application/text", <<>>}, [], []),
    ?assertEqual("Put Successful!", Body),
    ?assert(is_list(Headers)),
    ?assertMatch({"HTTP/1.1",201,"Created"}, Status).

delete_api(_Config) ->
    {ok, {Status, Headers, Body}} =
        httpc:request(delete, {"http://localhost:8080/mikbodo", [], "application/text", <<>>}, [], []),
    ?assertEqual("Delete Successful!", Body),
    ?assert(is_list(Headers)),
    ?assertMatch({"HTTP/1.1",204,"No Content"}, Status).

%%%****************************************************************************
%%% Internal functions
%%%****************************************************************************
