/*
 * Tomasz Kępa <tk359746@students.mimuw.edu.pl>
 * Zadanie 2 JPP - prolog
 */

:- [fixtures].
:- [printers].

:- use_module(library(lists)).

% STRUKTURY DANYCH

% gramatyka(SymbolPoczatkowy, ZbiorProdukcji)
% prod(NazwaNieterminala, ListaPrawychStronProdukcji)
% nt(Nieterminal)

% production(NazwaNieterminala, PrawaStronaProdukcji)
% situationSet(Produkcje, SkądPrzychodzę), SkądPrzychodzę - lista par - litera, numer

% transition(Symbol, NumerSytuacji)
% automat(ListaProdukcji, TabelaActionGoTo)


% createAutomaton(ZbiorySytuacjiLR, Automat, Info)


createLR(Grammar, Automat, Info) :-
  expandGrammar(Grammar, ProductionList),
  createSituationSets(ProductionList, SituationSetList),
  createAutomaton(SituationSetList, Automat, Info).


% expandGrammar(Gramatyka, RozszerzonaListaProdukcji)
expandGrammar(gramatyka(InitialSymbol, ProductionList), ExplandedProductionList) :-
  flattenProductions(ProductionList, FlatProductionList),
  addInitialProduction(InitialSymbol, FlatProductionList, ExplandedProductionList).


% flattenProductions(ListaProdukcji, SpłaszczonaListaProdukcji)
flattenProductions(ProductionList, FlatProductionList) :- flattenProductions(ProductionList, [], FlatProductionList).

flattenProductions([], Acc, FlatProductionList) :- reverse(Acc, FlatProductionList).
flattenProductions([prod(Symbol, [H | T]) | ProdTail], Acc, FlatProductionList) :-
  flattenProductions([prod(Symbol, T) | ProdTail], [production(Symbol, H) | Acc], FlatProductionList).
flattenProductions([prod(_, []) | ProdTail], Acc, FlatProductionList) :-
  flattenProductions(ProdTail, Acc, FlatProductionList).


% addInitialProduction(PoczątkowySymbol, ListaProdukcji, RozszerzonaListaProdukcji)
addInitialProduction(InitialSymbol, FlatProductionList, [production(`Z`, [ InitialSymbol, `#`]) | FlatProductionList]).


% createSituationSets(ListaProdukcji, ListaZbiorówSytuacji)
createSituationSets(ProductionList, SituationSetList) :-
  ProductionList = [production(`Z`, RH) | _],
  createSituationSets(ProductionList, [ situationSet([production(`Z`, [dot | RH])], []) ], [], SituationSetList).

% createSituationSets(ListaProdukcji, ZbiorySytuacjiDoPrzetworzenia, Akumulator, ListaZbiorówSytuacji)
createSituationSets(_, [], Acc, Result) :- reverse(Acc, Result).
createSituationSets(ProductionList, [H | T], Acc, Result) :-
  H = situationSet(SituationSet, ComingFrom),
  expandSituationSet(SituationSet, ProductionList, ExpandedSituationSet),
  zipSituationSets(SituationSetList, _, Acc),
  ( member(ExpandedSituationSet, SituationSetList)
    -> (
      addSituationSet(situationSet(ExpandedSituationSet, ComingFrom), Acc, NewAcc),
      createSituationSets(ProductionList, T, NewAcc, Result)
    )
    ; (
      length(Acc, SetNumber),
      nextSituations(ExpandedSituationSet, SetNumber, NewSets),
      mergeSituationSets(NewSets, T, NT),
      createSituationSets(ProductionList, NT, [situationSet(ExpandedSituationSet, ComingFrom) | Acc], Result)
    )
  ).


% zipSituationSets(ListaZbiorówSytuacji, ListaSkądPrzychodzę)
zipSituationSets([], [], []).
zipSituationSets([ProductionSet | PST], [ComingFrom | CFL],
                 [situationSet(ProductionSet, ComingFrom) | SST]) :-
  zipSituationSets(PST, CFL, SST).


mergeSituationSets([], SS, SS).
mergeSituationSets([H | T], Acc, SS) :-
  H = situationSet(SituationSet, _),
  zipSituationSets(SituationSetList, _, Acc),
  ( member(SituationSet, SituationSetList)
    -> (
        addSituationSet(H, Acc, NewAcc),
        mergeSituationSets(T, NewAcc, SS)
      )
    ; mergeSituationSets(T, [H | Acc], SS)
  ).

addSituationSet(S, Set, NewSet) :-
  addSituationSet(S, Set, [], NewSet).

addSituationSet(_, [], Acc, Result) :- reverse(Acc, Result).
addSituationSet(S, [H | T], Acc, Result) :-
  S = situationSet(Situations, Origins),
  ( H = situationSet(Situations, O)
    -> (
      append(Origins, O, R),
      remove_dups(R, Rs),
      addSituationSet(S, T, [situationSet(Situations, Rs) | Acc], Result)
    )
    ; addSituationSet(S, T, [H | Acc], Result)
  ).


nextSituations(SituationSet, SetNumber, Result) :-
  allAfterDot(SituationSet, SymbolList),
  nextSituations(SymbolList, SituationSet, SetNumber, [], Result).

nextSituations([], _, _, Result, Result).
nextSituations([H | T], SituationSet, SetNumber, Acc, Result) :-
  goto(SituationSet, H, NewSet),
  nextSituations(T, SituationSet, SetNumber, [situationSet(NewSet, [(H, SetNumber)]) | Acc], Result).


% createSituationSet(PoczątkoweSytuacje, ListaProdukcji, ZbiórSytuacjiLR)
expandSituationSet(InitialSituationSet, ProductionList, ResultSitutationSet) :-
  expandSituationSet(InitialSituationSet, ProductionList, [], ResultSitutationSet).

expandSituationSet([], _, ResultSitutationSet, SortedResult) :- sort(ResultSitutationSet, SortedResult).
expandSituationSet([H | T], ProductionList, Acc, ResultSitutationSet) :-
  member(H, Acc),
  expandSituationSet(T, ProductionList, Acc, ResultSitutationSet).
expandSituationSet([H | T], ProductionList, Acc, ResultSitutationSet) :-
  nonmember(H, Acc),
  ( nonterminalAfterDot(H, S)
    -> ( productionsForSymbol(S, ProductionList, Prods),
         append(T, Prods, ET),
         remove_dups(ET, PET),
         expandSituationSet(PET, ProductionList, [H | Acc], ResultSitutationSet) )
    ;  expandSituationSet(T, ProductionList, [H | Acc], ResultSitutationSet)
  ).


productionsForSymbol(Symbol, Productions, Result) :- productionsForSymbol(Symbol, Productions, [], Result).

productionsForSymbol(_, [], Result, Result).
productionsForSymbol(S, [production(X, Prod) | Tail], Acc, Result) :-
  ( X == S
   -> productionsForSymbol(S, Tail, [production(S, [dot | Prod]) | Acc], Result)
   ;  productionsForSymbol(S, Tail, Acc, Result)
  ).


nonterminalAfterDot(production(_, [dot, nt(X) | _]), X).
nonterminalAfterDot(production(S, [_ | T]), Result) :- nonterminalAfterDot(production(S, T), Result).


symbolAfterDot(production(_, [dot, X | _]), X).
symbolAfterDot(production(S, [_ | T]), Result) :- symbolAfterDot(production(S, T), Result).


allAfterDot(ProductionList, SymbolList) :- allAfterDot(ProductionList, [], SymbolList).

allAfterDot([], SymbolList, SortedSymbolList) :- remove_dups(SymbolList, SortedSymbolList).
allAfterDot([H | T], Acc, Result) :-
  symbolAfterDot(H, S)
  -> allAfterDot(T, [S | Acc], Result)
  ;  allAfterDot(T, Acc, Result).


goto(SituationSet, Symbol, Result) :- goto(SituationSet, Symbol, [], Result).

goto([], _, Result, SortedResult) :- remove_dups(Result, SortedResult).
goto([H | T], Symbol, Acc, Result) :-
  ( symbolAfterDot(H, Symbol)
    -> ( moveDot(H, NH),
         goto(T, Symbol, [NH | Acc], Result) )
    ; goto(T, Symbol, Acc, Result)
  ).


moveDot(Before, After) :- moveDot(Before, [], After).

moveDot(production(S, [dot, X | Tail]), Acc, production(S, Result)) :-
  reverse(Acc, RevAcc),
  append(RevAcc, [X, dot | Tail], Result).
moveDot(production(S, [X | Tail]), Acc, Result) :-
  X \= dot,
  moveDot(production(S, Tail), [X | Acc], Result).

nonmember(Element, List) :- \+ member(Element, List).

remove_dups(List, Set) :- % built in in sicstus
  list_to_set(List, SList),
  sort(SList, Set).

accept(_, _) :- true.
