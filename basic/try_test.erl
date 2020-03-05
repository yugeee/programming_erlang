-module(try_test).
-export([demo1/0]).
-export([demo2/0]).

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'Exit', a};
generate_exception(5) -> erlang:error(a).

demo1() -> 
    [catcher(I) || I <- [1,2,3,4,5]].

catcher(N) ->
    try generate_exception(N) of
        % Val は返り値
        Val -> {N, normal, Val}
    catch
        %v該当するエラーの形式に紐づく
        throw:X -> {N, caught, thrown, X};
        exit:X ->  {N, caught, exited, X};
        error:X -> {N, caught, error, X}
    end.

demo2() ->
    try generate_exception(5)
    catch
        error:X ->
            {X, erlang:get_stacktrace()}
        end.