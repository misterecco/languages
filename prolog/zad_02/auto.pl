/*
 * Tomasz Kępa <tk359746@students.mimuw.edu.pl>
 * Zadanie 2 JPP - prolog
 */

:- use_module(library(lists)).

prodList(pl1, [
        prod(`Z`, [
            [nt(`F`), `#`]
        ]),
        prod(`F`, [
            [`(`, nt(`L`), `)`]
        ]),
        prod(`L`, [
            [nt(`E`), nt(`L`)],
            []
        ]),
        prod(`E`, [
            [nt(`F`)],
            [`a`]
        ])
    ]
).

productionList(X, Y) :- 
  prodList(X, L),
  flattenProductions(L, Y).

initialProd(p1, production(`Z`, [dot, nt(`F`), `#`])).
initialProd(p2, production(`F`, [`(`, dot, nt(`L`), `)`])).

printList([]).
printList([H | T]) :- 
  write(H),   
  nl, 
  printList(T).

% ?- productionList(pl1, PL), initialProd(p1, P), expandSituation(P, PL, EP).
% ?- productionList(pl1, PL), initialProd(p1, P), expandSituation(P, PL, EP), printList(EP).


% gramatyka(SymbolPoczatkowy, ZbiorProdukcji).
% prod(NazwaNieterminala, ListaPrawychStronProdukcji)
% nt(Nieterminal)

% expandGrammar(Gramatyka, RozszerzonaListaProdukcji)
% createSituationSets(ListaProdukcji, ZbiorySytuacjiLR)
% createAutomaton(ZbiorySytuacjiLR, Automat, Info)
% createSituationSet(PoczątkoweSytuacje, ListaProdukcji, ZbiórSytuacjiLR)
% addSituationSet(ListaZbiorówSytacji, NowyZbiórSytacji, NowaListaZbiorówSytuacji)


% transition(Symbol, NumerSytuacji)
% situationSet(Produkcje, Przejścia)
% automat(ListaProdukcji, TabelaActionGoTo)

createLR(Grammar, Automat, Info) :- 
  expandGrammar(Grammar, ProductionList),
  createSituationSets(ProductionList, SituationSets),
  createAutomaton(SituationSets, Automat, Info).


expandGrammar(gramatyka(InitialSymbol, ProductionList), ExplandedProductionList) :-
  flattenProductions(ProductionList, FlatProductionList),
  addInitialProduction(InitialSymbol, FlatProductionList, ExplandedProductionList).


flattenProductions(ProductionList, FlatProductionList) :- flattenProductions(ProductionList, [], FlatProductionList).

flattenProductions([], FlatProductionList, FlatProductionList).
flattenProductions([prod(Symbol, [H | T]) | ProdTail], Acc, FlatProductionList) :- 
  flattenProductions([prod(Symbol, T) | ProdTail], [production(Symbol, H) | Acc], FlatProductionList).
flattenProductions([prod(_, []) | ProdTail], Acc, FlatProductionList) :-
  flattenProductions(ProdTail, Acc, FlatProductionList).


addInitialProduction(InitialSymbol, FlatProductionList, [production(`Z`, [ InitialSymbol, `#`]) | FlatProductionList]).
  

expandSituationSet(InitialSituationSet, ProductionList, FinalSituationSet) :-
  expandSituationSet(InitialSituationSet, ProductionList, [], FinalSituationSet).

expandSituationSet([], _, FinalSituationSet, FinalSituationSet).
expandSituationSet([H | T], ProductionList, Acc, FinalSituationSet) :- 
  expandSituation(H, ProductionList, EH),
  append(Acc, EH, NewAcc),
  remove_dups(NewAcc, SortedNewAcc),
  expandSituationSet(T, ProductionList, SortedNewAcc, FinalSituationSet).


remove_dups(List, Set) :- % built in in sicstus
  list_to_set(List, SList),
  sort(SList, Set).


expandSituation(Situation, ProductionList, ResultSitutationSet) :- 
  expandSituation([Situation], ProductionList, [], ResultSitutationSet).

expandSituation([], _, ResultSitutationSet, SortedResult) :- sort(ResultSitutationSet, SortedResult).
expandSituation([H | T], ProductionList, Acc, ResultSitutationSet) :-
  member(H, Acc),
  expandSituation(T, ProductionList, Acc, ResultSitutationSet).
expandSituation([H | T], ProductionList, Acc, ResultSitutationSet) :-
  \+ member(H, Acc), % nonmember in sicstus
  ( nextToDot(H, S)
    -> ( productionsForSymbol(S, ProductionList, Prods),
         append(T, Prods, ET),
         remove_dups(ET, PET),
         expandSituation(PET, ProductionList, [H | Acc], ResultSitutationSet) )
    ;  expandSituation(T, ProductionList, [H | Acc], ResultSitutationSet)
  ).

productionsForSymbol(Symbol, Productions, Result) :- productionsForSymbol(Symbol, Productions, [], Result).

productionsForSymbol(_, [], Result, Result).
productionsForSymbol(S, [production(X, Prod) | Tail], Acc, Result) :- 
  ( X == S
   -> productionsForSymbol(S, Tail, [production(S, [dot | Prod]) | Acc], Result)
   ;  productionsForSymbol(S, Tail, Acc, Result)
  ).

nextToDot(production(_, [dot, nt(X) | _]), X).
nextToDot(production(S, [_ | T]), Result) :- nextToDot(production(S, T), Result).
  

% TODO: make it more efficient (at least use open list or acc)
addSituationSet(SituationSetList, NewSet, NewSituationSetList) :-
  sort(NewSet, SortedNewSet),
  ( member(SortedNewSet, SituationSetList)
    -> NewSituationSetList = SituationSetList
    ; append(SituationSetList, [SortedNewSet], NewSituationSetList) 
  ).






accept(_, _) :- true.
