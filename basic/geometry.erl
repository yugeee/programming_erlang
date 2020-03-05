-module(geometry).
% 関数名/引数の個数（アリティと言う）
-export([area/1]).

area({rectangle, Width, Ht}) -> Width * Ht; %節で区切って同じ名前で関数を定義できる
area({circle, R}) -> 3.14159 * R * R;
area({square, X}) -> X * X.

