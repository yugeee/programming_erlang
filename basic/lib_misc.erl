-module(lib_misc).
-export([for/3]).
-export([qsort/1]).
-export([pythag/1]).
-export([perms/1]).
-export([odds_and_evens/1]).
-export([odds_and_evens_acc/1]).
-export([on_exit/2]).

% 簡単なfor文
for(Max, Max, F) -> [F(Max)];
for(I, Max, F)   -> [F(I)|for(I+1, Max, F)].

% クイックソート
qsort([]) -> [];
qsort([Pivot|T]) -> 
    % リスト内記法 [F(X) || X <- L ] = map関数
    qsort([X || X <- T, X < Pivot])
    % ++ はリスト連結 -- はリスト差分を作る
    ++ [Pivot] ++
    qsort([X || X <- T, X >= Pivot]).

% ピタゴラス数 A^2 + B^2 = C^2 となる組み合わせ
pythag(N) ->
    [ {A,B,C} ||
        A <- lists:seq(1,N),
        B <- lists:seq(1,N),
        C <- lists:seq(1,N),
        A+B+C =< N,
        A*A+B*B =:= C*C
    ].

% アナグラム
perms([]) -> [[]];
perms(L) -> [[H|T] || H <- L, T <- perms(L-- [H])].


% アキュムレータ
% リストを2回辿っているので効率が悪い
odds_and_evens(L) ->
    Odds = [X || X <- L, (X rem 2) =:= 1],
    Evens = [X || X <- L, (X rem 2) =:= 0],
    {Odds, Evens}.

odds_and_evens_acc(L) ->
    odds_and_evens_acc(L, [], []).

odds_and_evens_acc([H | T], Odds, Evens) ->
    case (H rem 2) of
        1 -> odds_and_evens_acc(T, [H|Odds], Evens);
        0 -> odds_and_evens_acc(T, Odds, [H|Evens])
    end;
odds_and_evens_acc([], Odds, Evens) ->
    {lists:reverse(Odds), lists:reverse(Evens)}.

on_exit(Pid, Fun) ->
    spawn(fun() ->
            process_flag(trap_exit, true),
            link(Pid),
            receive
                {'Exit', Pid, Why} ->
                    Fun(Why)
            end
    end).