/*
 * Tomasz Kępa <tk359746@students.mimuw.edu.pl>
 * Zadanie 2 JPP - prolog
 */

:- [fixtures].
:- [printers].

:- use_module(library(lists)).


% gramatyka(SymbolPoczatkowy, ZbiorProdukcji).
% prod(NazwaNieterminala, ListaPrawychStronProdukcji)
% nt(Nieterminal)

% transition(Symbol, NumerSytuacji)
% situationSet(Produkcje, Przejścia)
% automat(ListaProdukcji, TabelaActionGoTo)


% createAutomaton(ZbiorySytuacjiLR, Automat, Info)


createLR(Grammar, Automat, Info) :- 
  expandGrammar(Grammar, ProductionList),
  createSituationSets(ProductionList, SituationSets),
  createAutomaton(SituationSets, Automat, Info).


% expandGrammar(Gramatyka, RozszerzonaListaProdukcji)
expandGrammar(gramatyka(InitialSymbol, ProductionList), ExplandedProductionList) :-
  flattenProductions(ProductionList, FlatProductionList),
  addInitialProduction(InitialSymbol, FlatProductionList, ExplandedProductionList).


% flattenProductions(ListaProdukcji, PłaskaListaProdukcji)
flattenProductions(ProductionList, FlatProductionList) :- flattenProductions(ProductionList, [], FlatProductionList).

flattenProductions([], Acc, FlatProductionList) :- reverse(Acc, FlatProductionList).
flattenProductions([prod(Symbol, [H | T]) | ProdTail], Acc, FlatProductionList) :- 
  flattenProductions([prod(Symbol, T) | ProdTail], [production(Symbol, H) | Acc], FlatProductionList).
flattenProductions([prod(_, []) | ProdTail], Acc, FlatProductionList) :-
  flattenProductions(ProdTail, Acc, FlatProductionList).


% addInitialProduction(PoczątkowySymbol, ListaProdukcji, RozszerzonaListaProdukcji)
addInitialProduction(InitialSymbol, FlatProductionList, [production(`Z`, [ InitialSymbol, `#`]) | FlatProductionList]).
  

% createSituationSets(ListaProdukcji, ZbiorySytuacjiLR)
createSituationSets(ProductionList, SituationSets) :- 
  ProductionList = [production(`Z`, RH) | _],
  createSituationSets(ProductionList, [[production(`Z`, [dot | RH])]], [], SituationSets).

%createSituationSets(ListaProdukcji, ZbiorySytuacjiDoPrzetworzenia, Akumulator, ListaZbiorówSytuacji)
createSituationSets(_, [], Acc, Result) :- reverse(Acc, Result).
createSituationSets(LP, [H | T], Acc, Result) :-
  expandSituationSet(H, LP, EH),
  ( member(EH, Acc)
    -> createSituationSets(LP, T, Acc, Result)
    ; (
      nextSituations(EH, NewSets),
      append(NewSets, T, NT),
      createSituationSets(LP, NT, [EH | Acc], Result)
    )
  ).


nextSituations(SituationSet, Result) :- 
  allAfterDot(SituationSet, SymbolList),
  nextSituations(SymbolList, SituationSet, [], Result).

nextSituations([], _, Acc, Result) :- remove_dups(Acc, Result).
nextSituations([H | T], SituationSet, Acc, Result) :-
  goto(SituationSet, H, NewSet),
  nextSituations(T, SituationSet, [NewSet | Acc], Result).


% createSituationSet(PoczątkoweSytuacje, ListaProdukcji, ZbiórSytuacjiLR)
expandSituationSet(InitialSituationSet, ProductionList, ResultSitutationSet) :- 
  expandSituationSet(InitialSituationSet, ProductionList, [], ResultSitutationSet).

expandSituationSet([], _, ResultSitutationSet, SortedResult) :- sort(ResultSitutationSet, SortedResult).
expandSituationSet([H | T], ProductionList, Acc, ResultSitutationSet) :-
  member(H, Acc),
  expandSituationSet(T, ProductionList, Acc, ResultSitutationSet).
expandSituationSet([H | T], ProductionList, Acc, ResultSitutationSet) :-
  \+ member(H, Acc), % nonmember in sicstus
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
  

remove_dups(List, Set) :- % built in in sicstus
  list_to_set(List, SList),
  sort(SList, Set).

accept(_, _) :- true.
