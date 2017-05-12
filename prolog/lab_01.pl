dziecko(jasio, ewa, jan).
dziecko(stasio, ewa, jan).
dziecko(basia, anna, piotr).
dziecko(jan, ela, jakub).

ojciec(Dziecko, Ojciec) :- dziecko(Dziecko, _, Ojciec).

matka(Dziecko, Matka) :- dziecko(Dziecko, Matka, _).

wspolnaMama(Dziecko1, Dziecko2, Matka) :- matka(Dziecko1, Matka),
                                          matka(Dziecko2, Matka),
                                          Dziecko1 @< Dziecko2.

rodzic(Dziecko, Rodzic) :- matka(Dziecko, Rodzic).
rodzic(Dziecko, Rodzic) :- ojciec(Dziecko, Rodzic).

babcia(Dziecko, Babcia) :- rodzic(Dziecko, Rodzic), matka(Rodzic, Babcia).

wnuk(Wnuk, Dziadek) :- rodzic(Wnuk, Rodzic), rodzic(Rodzic, Dziadek).

przodek(Przodek, Potomek) :- rodzic(Potomek, Przodek).

przodek(Przodek, Potomek) :- rodzic(Potomek, X), przodek(Przodek, X).


% nat(0).
% nat(s(X)) :- nat(X).

nat(0).
nat(X) :- X > 0,
          Y is X - 1,
          nat(Y).

% plus(X, Y, Z) iff X + Y = Z
plus(0, X, X).
plus(s(X), Y, s(Z)) :- plus(X, Y, Z).

% minus(X, Y, Z) iff X - Y = Z
minus(X, Y, Z) :- plus(Z, Y, X).

% fib(k, n) iff n = kth Fibonacci number
fib(0, 0).
fib(s(0), s(0)).
fib(s(s(X)), Y) :- fib(X, F1),
                   fib(s(X), F2),
                   plus(F1, F2, Y).


lista([]).
lista([_ | _]).

pierwszy(E, [E | _]).

ostatni(E, [E]).
ostatni(E, [_ | T]) :- ostatni(E, T).

element(E, [E | _]).
element(E, [_ | T]) :- element(E, T).
