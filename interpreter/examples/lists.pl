head(H, [H | _]).

?- head(X, "kultura").

member(H, [H | T]).
member(H, [_ | T]) :- element(H, T).

?- member(1, [1, 2, 3, 4, 5]).
?- member(X, [1, 2, 3, 4, 5]).


append([], L, L).
append([H | T], L1, [H | LS]) :- append(T, L1, LS).

?- append(X, Y, [1,2,3,4,5,6]).
