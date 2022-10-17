%% =========================================
%% module: db
%% author: zhl
%% desc:   postgresql模块
%% time:   2017/09/22
%% =========================================

-module(epgsql_poolboy_app).
-behaviour(application).
-behaviour(supervisor).

-export([start/0, stop/0, squery/2, equery/3]).
-export([start/2, stop/1]).
-export([init/1]).

start() ->
	start(0, 0).

stop() ->
	application:stop(?MODULE).

start(_Type, _Args) ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

stop(_State) ->
	ok.

init([]) ->
	{ok, Pools} = application:get_env(main, epg_pools),
	PoolSpecs = lists:map(fun({Name, SizeArgs, WorkerArgs}) ->
		PoolArgs = [{name, {local, Name}}, {worker_module, epgsql_poolboy_sub}] ++ SizeArgs,
		poolboy:child_spec(Name, PoolArgs, WorkerArgs)
						  end, Pools),
	{ok, {{one_for_one, 10, 10}, PoolSpecs}}.

squery(PoolName, Sql) ->
	poolboy:transaction(PoolName, fun(Worker) ->
		gen_server:call(Worker, {squery, Sql})
								  end).

equery(PoolName, Stmt, Params) ->
	poolboy:transaction(PoolName, fun(Worker) ->
		gen_server:call(Worker, {equery, Stmt, Params})
								  end).

