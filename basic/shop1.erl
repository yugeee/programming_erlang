-module(shop1).
-export([total/1]).

% 再帰
total([{What, N} | T]) -> shop:cost(What) * N + total(T);
total([])              -> 0.
