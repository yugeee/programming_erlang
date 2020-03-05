-module(area_server_final).
-export([start/0, area/2]).

% サーバ起動
start() -> spawn(fun loop/0).

% クライアント受付
area(Pid, What) ->
    rpc(Pid, What).


% クライアント送信
rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
        {Pid, Response} ->
            Response
    end.

% サーバ
loop() ->
    receive
        {From, {rectangle, Width, Ht}} ->
            From ! {self(), Width * Ht},
            %io:format("矩形の面積 ~p~n", [Width * Ht]),
            loop();

        {From, {circle, R}} ->
            From ! {self(), 3.14159 * R * R},
            %io:format("円の面積 ~p~n", [3.14159 * R * R]),
            loop();

        {From, Other} ->
            From ! {self(), {error, Other}},
            %io:format("なにこれ ~p~n", [Other]),
            loop()
    end.