-module(area_server).
-export([loop/0]).

loop() ->
    receive
        {rectangle, Width, Ht} ->
            io:format("矩形の面積 ~p~n", [Width * Ht]),
            loop();

        {circle, R} ->
            io:format("円の面積 ~p~n", [3.14159 * R * R]),
            loop();

        Other ->
            io:format("なにこれ ~p~n", [Other]),
            loop()
    end.