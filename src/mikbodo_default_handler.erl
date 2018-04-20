-module(mikbodo_default_handler).

-export([
    handle_put/1,
    handle_get/1,
    handle_post/1,
    handle_delete/1
]).

handle_put(Request) ->
    {201, <<"Put Successful!">>}.

handle_get(Request) ->
    {200, <<"Get Successful!">>}.

handle_post(Request) ->
    {200, <<"Post Successful!">>}.

handle_delete(Request) ->
    {204, <<"Delete Successful!">>}.
