head(H, [H | _]).

?- head(X, "kultura").

member(H, [H | T]).
member(H, [_ | T]) :- member(H, T).

?- member(1, [1, 2, 3, 4, 5]).
?- member(X, [1, 2, 3, 4, 5]).

append([], L, L).
append([H | T], L, [H | LS]) :- append(T, L, LS).

?- append(X, Y, [1,2,3,4,5,6]).


przed(X, Y, List) :- append(L1, [Y | _], List), member(X, L1).

?- przed(X, Y, [1,2,3,4,5]).
