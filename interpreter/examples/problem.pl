char(s(0)).
nat(0).
nat(s(0)).
nat(s(s(0))).
a(X) :- nat(X), char(X).
?- a(X).


nat(0).
nat(s(0)).
nat(s(s(0))).
a(X) :- nat(X), X == s(0).
?- a(X).
