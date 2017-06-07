:- [auto].

% test(+NazwaGramatyki, +ListaSlowDoZbadania)
test(NG, ListaSlow) :-
  grammar(NG, G),
  createLR(G, Automat, Info),
  (Info =  konflikt(Opis)
        -> format(`Konflikt: ~p`, Opis), nl
        ;  checkWords(ListaSlow, Automat) ).

checkWords([], _) :- format(`Koniec testu.\n`).
checkWords([S|RS], Automat) :-
  format(" Slowo: ~p ", [S]),
  (accept(Automat, S) -> true; format(`NIE `)),
  format(`nalezy.\n`),
  checkWords(RS, Automat).


% LR(0)
grammar(ex1, gramatyka(`E`,
    [prod(`E`, [[nt(`E`), `+`, nt(`T`)], [nt(`T`)]]),
    prod(`T`, [[id], [`(`, nt(`E`), `)`]]) ])).

% LR(0)
grammar(ex2, gramatyka(`A`, [prod(`A`, [[nt(`A`), x], [x]])])).

% SLR(1)
grammar(ex3, gramatyka(`A`, [prod(`A`, [[x, nt(`A`)], [x]])])).

% nie SLR(1)
grammar(ex4, gramatyka(`A`,
    [prod(`A`, [[x, nt(`B`)], [nt(`B`), y], []]),
    prod(`B`, [[]])])).

% nie SLR(1)
grammar(ex5, gramatyka(`S`,
    [prod(`S`, [[id], [nt(`V`), `:=`, nt(`E`)]]),
    prod(`V`, [[id], [id, `[`, nt(`E`), `]`]]),
    prod(`E`, [[v]])])).

% nie SLR(1)
grammar(ex6, gramatyka(`A`,
    [prod(`A`, [[x], [nt(`B`), nt(`B`)]]),
    prod(`B`, [[x]])])).


?- test(ex1, [[id], [`(`,id,`)`], [id,`+`,ident], [id,`+`,id]]).
?- test(ex2, [[x], [x,x], [x,x,x], [`A`]]).

?- test(ex3, [[x]]).
?- test(ex4, [[x]]).
?- test(ex5, [[x]]).
?- test(ex6, [[x]]).
