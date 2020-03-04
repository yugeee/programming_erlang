-module(area_server2).
-export([rpc/2, loop/0]).

% クライアント
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