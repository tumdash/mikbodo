-module(mikbodo_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Request, State) ->
    {ok, HandlerModule} = application:get_env(mikbodo, module_handler),
%    {ok, GuardTimer} = application:get_env(mikbodo, guardier),
    HandlerFun = case cowboy_req:method(Request) of
        Bin when is_binary(Bin) ->
            handle_name(Bin);
        Rest ->
            error:logger("HTTP method unknown", Rest)
    end,
    Response = try request_back(HandlerModule:HandlerFun(Request), Request) of
        ReqBack ->
            ReqBack
    catch
        _:Reason ->
            error:logger("Handling response failed", Reason),
            cowboy_handler:terminate({crash, handing_crash}, Request, State)
    end,
    {ok, Response, State}.


request_back({Status, BinBody}, Request) ->
    request_back({Status, <<"text/plain">>, #{}, BinBody}, Request);
request_back({Status, AppHeaders, BinBody}, Request) ->
    request_back({Status, <<"text/plain">>, AppHeaders, BinBody}, Request);
request_back({Status, ContentType, AppHeaders, BinBody}, Request)
        when is_number(Status), is_binary(ContentType),
        is_binary(BinBody), is_map(AppHeaders) ->
    cowboy_req:reply(Status,
                     maps:merge(AppHeaders, #{<<"content-type">> => ContentType}),
                     BinBody,
                     Request
    ).

handle_name(<<"PUT">>) ->
    handle_put;
handle_name(<<"GET">>) ->
    handle_get;
handle_name(<<"POST">>) ->
    handle_post;
handle_name(<<"DELETE">>) ->
    handle_delete;
handle_name(_Other) ->
    undefined.

