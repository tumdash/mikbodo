%%%****************************************************************************
%%% @edoc Webserver module
%%%
%%%
%%% @copyright 2018 Tumdash
%%%****************************************************************************
-module(mikbodo_webserver_srv).
-behavior(gen_server).
-author('nickolay.kovalev@gmail.com').

%export API
-export([start_link/0]).

%gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

%%%****************************************************************************
%%% Macro Definitions
%%%****************************************************************************
-define(SERVER, ?MODULE).

%%%****************************************************************************
%%% Includes
%%%****************************************************************************

%%%****************************************************************************
%%% API functions
%%%****************************************************************************
%%%----------------------------------------------------------------------------
-spec start_link() -> {ok, pid()} | ignore | {error, term()}.
%%%----------------------------------------------------------------------------
%%% @edoc Initiates gen_server for start
%%%----------------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%****************************************************************************
%%% Gen_server callbacks
%%%****************************************************************************
init(State) ->
    {ok, Port} = application:get_env(mikbodo, port),
    {ok, Endpoint} = application:get_env(mikbodo, endpoint),
    {ok, IdleTimeout} = application:get_env(mikbodo, idle_timeout),
    start_cowboy(Port, Endpoint, IdleTimeout),
    {ok, State}.

handle_call(_Req, _From, State) ->
    {reply, ok, State}.

handle_cast(_Req, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

%%%****************************************************************************
%%% Internal functions
%%%****************************************************************************
start_cowboy(Port, Endpoint, IdleTimeout) ->
    Dispatch = cowboy_router:compile([
        {'_', [
                {"/" ++ Endpoint, mikbodo_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, Port}],
        #{
            env => #{dispatch => Dispatch},
            idle_timeout => IdleTimeout
        }
    ).
