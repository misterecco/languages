nat(0).
nat(s(X)) :- nat(X),

?- nat(s(s(0))).
