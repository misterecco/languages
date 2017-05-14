even(0).
even(s(X)) :- \+ even(X).

?- even(s(s(0))).
?- even(s(s(s(0)))).

odd(s(X)) :- \+ odd(X).

?- odd(s(s(0))).
?- odd(s(s(s(0)))).
