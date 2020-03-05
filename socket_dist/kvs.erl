-module(kvs).
-export([start/0, store/2, lookup/1]).

% erl -sname 名前 でErlangノード名を決定してシェルを立ち上げられる
% rpc:call(Erlangノード名@アドレス, module名, 関数名, [引数1, 引数2]) でerlangプログラムを遠隔操作できる

% サーバ起動
start() ->
    register(kvs, spawn(fun() -> loop() end)).

% kvsにKey-Valueをいれる
store(Key, Value) ->
    rpc({store, Key, Value}).

% KeyからValueを検索する
lookup(Key) ->
    rpc({lookup, Key}).

% Remote Procedure Call（遠隔処理呼び出し）別環境の関数を呼び出したりすること
rpc(Q) ->
    kvs ! {self(), Q},
    receive
        {kvs, Reply} ->
            Reply
    end.

% メイン処理
loop() ->
    receive
        % store処理
        {From, {store, Key, Value}} ->
            put(Key, {ok, Value}),
            From ! {kvs, true},
            loop();
        % lookup処理
        {From, {lookup, Key}} ->
            From ! {kvs, get(Key)},
            loop()
    end.
