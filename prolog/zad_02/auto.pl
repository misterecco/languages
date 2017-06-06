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

% pr(NazwaNieterminala, PrawaStronaProdukcji)
% state(Produkcje, KrawędziePrzychodzące)

% transition(Symbol, NumerSytuacji)
% automat(ListaProdukcji, TabelaActionGoTo)



% createLR(Gramatyka, Automat, Info)
createLR(Grammar, Automat, Info) :-
  expandGrammar(Grammar, ProdList),
  createGraph(ProdList, StateList),
  createAutomaton(StateList, Automat, Info).


% expandGrammar(Gramatyka, RozszerzonaListaProdukcji)
expandGrammar(gramatyka(InitialSymbol, ProdList), ExplandedProdList) :-
  flattenProductions(ProdList, FlatProdList),
  addInitialProduction(InitialSymbol, FlatProdList, ExplandedProdList).


% flattenProductions(ListaProdukcji, SpłaszczonaListaProdukcji)
flattenProductions(ProdList, FlatProdList) :-
  flattenProductions(ProdList, [], FlatProdList).

% flattenProductions(ListaProdukcji, Akumulator, SpłaszczonaListaProdukcji)
flattenProductions([], Acc, FlatProdList) :-
  reverse(Acc, FlatProdList).
flattenProductions([prod(S, [RHS | RHSTail]) | Tail], Acc, FlatProdList) :-
  flattenProductions([prod(S, RHSTail) | Tail], [pr(S, RHS) | Acc], FlatProdList).
flattenProductions([prod(_, []) | OtherProds], Acc, FlatProdList) :-
  flattenProductions(OtherProds, Acc, FlatProdList).


% addInitialProduction(PoczątkowySymbol, ListaProdukcji, RozszerzonaListaProdukcji)
addInitialProduction(S, ProdList, [pr(`Z`, [S, `#`]) | ProdList]).


% createGraph(ListaProdukcji, ListaStanów)
createGraph(ProdList, StateList) :-
  ProdList = [pr(`Z`, RHS) | _],
  createGraph(ProdList, [ state([pr(`Z`, [dot | RHS])], []) ], [], StateList).

% createGraph(ListaProdukcji, StanyDoPrzetworzenia, Akumulator, ListaStanów)
createGraph(_, [], Acc, StateList) :- reverse(Acc, StateList).
createGraph(ProdList, [StateStub | Tail], Acc, StateList) :-
  StateStub = state(SitSet, InEdges),
  expandSituationSet(SitSet, ProdList, ExpSitSet),
  zipStates(SituationSetList, _, Acc),
  ( member(ExpSitSet, SituationSetList)
    -> (
      addState(state(ExpSitSet, InEdges), Acc, NewAcc),
      createGraph(ProdList, Tail, NewAcc, StateList)
    )
    ; (
      length(Acc, StateNumber),
      nextStates(ExpSitSet, StateNumber, NewStateStubs),
      mergeStates(NewStateStubs, Tail, MergedStates),
      createGraph(ProdList, MergedStates, [state(ExpSitSet, InEdges) | Acc], StateList)
    )
  ).


% zipStates(ListaZbiorówSytuacji, ListaZbiorówKrawędziWchodzących, ListaStanów)
zipStates([], [], []).
zipStates([SitSet | SitSetTail], [InEdges | InEdgesTail],
                 [state(SitSet, InEdges) | OtherStates]) :-
  zipStates(SitSetTail, InEdgesTail, OtherStates).


% mergedStates(PierwszaListaStanów, DrugaListaStanów, ListaPołączonychStanów)
mergeStates([], MergedStates, MergedStates).
mergeStates([State | StateTail], Acc, MergedStates) :-
  State = state(SituationSet, _),
  zipStates(SituationSetList, _, Acc),
  ( member(SituationSet, SituationSetList)
    -> (
        addState(State, Acc, NewAcc),
        mergeStates(StateTail, NewAcc, MergedStates)
      )
    ; mergeStates(StateTail, [State | Acc], MergedStates)
  ).


% addState(Stan, ListaStanów, NowaListaStanów)
addState(State, StateList, NewStateList) :-
  addState(State, StateList, [], NewStateList).

% addState(Stan, ListaStanów, Akumulator, NowaListaStanów)
addState(_, [], ReversedStateList, StateList) :-
  reverse(ReversedStateList, StateList).
addState(State, [Head | Tail], Acc, Result) :-
  State = state(SituationSet, InEdges),
  ( Head = state(SituationSet, InEdgesHead)
    -> (
      append(InEdges, InEdgesHead, AllInEdges),
      remove_dups(AllInEdges, DedupedInEdges),
      addState(State, Tail, [state(SituationSet, DedupedInEdges) | Acc], Result)
    )
    ; addState(State, Tail, [Head | Acc], Result)
  ).


% nextStates(ZbiórSytuacji, NumberStanu, NoweStany)
nextStates(SituationSet, StateNumber, NewStates) :-
  allAfterDot(SituationSet, SymbolList),
  nextStates(SymbolList, SituationSet, StateNumber, [], NewStates).

% nextStates(ListaSymboli, ZbiórSytuacji, NumberStanu, Akumulator, NoweStany)
nextStates([], _, _, NewStates, NewStates).
nextStates([Symbol | Tail], SituationSet, StateNumber, Acc, NewStates) :-
  transition(SituationSet, Symbol, NewSet),
  nextStates(Tail, SituationSet, StateNumber,
             [state(NewSet, [ed(Symbol, StateNumber)]) | Acc], NewStates).


% createSituationSet(PoczątkoweSytuacje, ListaProdukcji, ZbiórSytuacjiLR)
expandSituationSet(InitialSituationSet, ProdList, ResultSitutationSet) :-
  expandSituationSet(InitialSituationSet, ProdList, [], ResultSitutationSet).


% expandSituationSet(ZbiórSytuacji, ListaProdukcji, Akumulator, RozszerzonyZbiórSytuacji)
expandSituationSet([], _, Acc, SortedResult) :- sort(Acc, SortedResult).
expandSituationSet([Head | Tail], ProdList, Acc, ResultSitutationSet) :-
  member(Head, Acc),
  expandSituationSet(Tail, ProdList, Acc, ResultSitutationSet).
expandSituationSet([Head | Tail], ProdList, Acc, ResultSitutationSet) :-
  nonmember(Head, Acc),
  ( nonterminalAfterDot(Head, S)
    -> ( productionsForSymbol(S, ProdList, Prods),
         append(Tail, Prods, ET),
         remove_dups(ET, PET),
         expandSituationSet(PET, ProdList, [Head | Acc], ResultSitutationSet) )
    ; expandSituationSet(Tail, ProdList, [Head | Acc], ResultSitutationSet)
  ).


% productionsForSymbol(Symbol, WszystkieProdukcje, ProdukcjeDlaSymbolu)
productionsForSymbol(Symbol, Productions, Result) :-
  productionsForSymbol(Symbol, Productions, [], Result).

% productionsForSymbol(Symbol, ListaProdukcji, Akumulator, ProdukcjeDlaSymbolu)
productionsForSymbol(_, [], Result, Result).
productionsForSymbol(S, [pr(X, Prod) | Tail], Acc, Result) :-
  ( X == S
   -> productionsForSymbol(S, Tail, [pr(S, [dot | Prod]) | Acc], Result)
   ;  productionsForSymbol(S, Tail, Acc, Result)
  ).


% nonterminalAfterDot(Produkcja, NieterminalZaKropką)
nonterminalAfterDot(pr(_, [dot, nt(X) | _]), X).
nonterminalAfterDot(pr(S, [_ | Tail]), Result) :-
  nonterminalAfterDot(pr(S, Tail), Result).


% symbolAfterDot(Produkcja, SymbolZaKropką)
symbolAfterDot(pr(_, [dot, X | _]), X).
symbolAfterDot(pr(S, [_ | Tail]), Result) :- symbolAfterDot(pr(S, Tail), Result).


% symbolAfterDot(ListaProdukcji, WszystkieSymboleWystępująceZaKropkami)
allAfterDot(ProdList, SymbolList) :- allAfterDot(ProdList, [], SymbolList).

% symbolAfterDot(ListaProdukcji, Akumulator, ListaSymboli)
allAfterDot([], SymbolList, SortedSymbolList) :-
  remove_dups(SymbolList, SortedSymbolList).
allAfterDot([Head | Tail], Acc, Result) :-
  symbolAfterDot(Head, Symbol)
  -> allAfterDot(Tail, [Symbol | Acc], Result)
  ;  allAfterDot(Tail, Acc, Result).


% transition(ZbiórSytuacji, NapotkanySymbol, ZalążkiNowychStanów)
transition(SituationSet, Symbol, NewStateStubs) :-
  transition(SituationSet, Symbol, [], NewStateStubs).

% transition(ListaSytuacji, NapotkanySymbol, Akumulator, ZalążkiNowychStanów)
transition([], _, Acc, Result) :- remove_dups(Acc, Result).
transition([Situation | Tail], Symbol, Acc, Result) :-
  ( symbolAfterDot(Situation, Symbol)
    -> ( moveDot(Situation, NewSituation),
         transition(Tail, Symbol, [NewSituation | Acc], Result) )
    ; transition(Tail, Symbol, Acc, Result)
  ).

% moveDot(Sytuacja, SytuacjaZPrzesuniętąKropką)
moveDot(Situation, NewSituation) :- moveDot(Situation, [], NewSituation).

% moveDot(Sytuacja, Akumulator, SytuacjaZPrzesuniętąKropką)
moveDot(pr(Nt, [dot, X | ProdTail]), Acc, pr(Nt, NewRHS)) :-
  reverse(Acc, RevAcc),
  append(RevAcc, [X, dot | ProdTail], NewRHS).
moveDot(pr(Nt, [X | ProdTail]), Acc, Result) :-
  X \= dot,
  moveDot(pr(Nt, ProdTail), [X | Acc], Result).



nonmember(Element, List) :- \+ member(Element, List).

remove_dups(List, Set) :- % built in in sicstus
  list_to_set(List, SList),
  sort(SList, Set).

accept(_, _) :- true.
