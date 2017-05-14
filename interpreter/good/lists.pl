head(H, [H | _]).

?- head(X, "kultura").

member(H, [H | T]).
member(H, [_ | T]) :- member(H, T).

?- member(1, [1, 2, 3, 4, 5]).
?- member(X, [1, 2, 3, 4, 5]).

append([], L, L).
append([H | T], L, [H | LS]) :- append(T, L, LS).

?- append(X, Y, [1,2,3,4,5,6]).
?- append("pro", "log", A).

% before (X, Y, L) iff X appears before Y on list L
before(X, Y, List) :- before(L1, [Y | _], List),
                      member(X, L1).

?- before(X, Y, [1,2,3,4,5]).
