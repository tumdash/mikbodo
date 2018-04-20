%%%-------------------------------------------------------------------
%% @doc mikbodo top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(mikbodo_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    SuperFlags = #{strategy => one_for_one, intensity => 1, period => 5},
    ChildSpecs = [
        #{id => main_webserver,
          start => {mikbodo_webserver_srv, start_link, []},
          restart => permanent,
          shutdown => brutal_kill,
          type => worker}
    ],
    {ok, {SuperFlags, ChildSpecs}}.

%%====================================================================
%% Internal functions
%%====================================================================
