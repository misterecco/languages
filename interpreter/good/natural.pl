% nat defines Peano natual numbers
nat(0).
nat(s(X)) :- nat(X).

?- nat(zero).
?- nat(s(s(s(0)))).

% plus(X, Y, Z) iff X + Y = Z
plus(0, X, X).
plus(s(X), Y, s(Z)) :- plus(X, Y, Z).

?- plus(X, Y, s(s(s(s(0))))).

% minus(X, Y, Z) iff X - Y = Z
minus(X, Y, Z) :- plus(Z, Y, X).

?- minus(s(s(0)), X, X).
