head(H, [H | _]).

?- head(X, "kultura").

element(H, [H | T]).
element(H, [_ | T]) :- element(H, T).

?- element(1, [1, 2, 3, 4, 5]).


append([], L, L).
append([H | T], L1, [H | LS]) :- append(T, L1, LS).

% ?- append("kom", "iniarz", L).
?- append(X, Y, [1,2,3,4,5,6]).
