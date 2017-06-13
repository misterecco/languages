/*
 * Tomasz Kępa <tk359746@students.mimuw.edu.pl>
 * Zadanie 2 JPP - prolog
 *
 *
 * W celu utworzenia automatu LR z danej gramatyki tworzony jest najpierw
 * graf stanów automatu, na podstawie którego tworzona jest tabela ACTION/GOTO
 * Automat LR składa się z wierszy (predykat row). Każdy wiersz odpowiada jednemu
 * stanowi w grafie. Pozycja na liście odpowiada numerowi odpowiedniengo stanu.
 * Każdy wiersz to term row(Redukcje, ListaAkcji, ListaGoto). Zarówno shift jak
 * i goto zawierają symbol oraz numer stanu, który zostanie wrzucony na stos.
 * Redukcje natomiast zawierają pełną produkcję, dzięki czemu nie trzeba pamiętać
 * już ani gramatyki ani pełnego grafu stanu - wystarczy tabela ACTION/GOTO
 */

% STRUKTURY DANYCH

% gramatyka(SymbolPoczatkowy, ZbiorProdukcji)
% prod(NazwaNieterminala, ListaPrawychStronProdukcji)
% nt(Nieterminal)

% pr(NazwaNieterminala, PrawaStronaProdukcji)
% state(Produkcje, KrawędzieWchodzące)
% ed(Symbol, NumerStanu)
% red(NazwaNieterminala, PrawaStronaProdukcji)
% shift(Symbol, NumerStanu)
% goto(Symbol, NumerStanu)
% row(Redukcje, ListaShift, ListaGoto)

:- use_module(library(lists)).

/*
 * createLR(+Gramatyka, -Automat, -Info)
 * Dla podanej gramatyki tworzy automat LR(0). W przypadku utworzenia automatu
 * parametr Info powinien mieć nadaną wartość yes,
 * a w przeciwnym przypadku jego wartością powinien być term
 * konflikt(Opis), gdzie Opis jest (czytelnym) opisem rozpoznanego
 * konfliktu, a parametr Automat powinien mieć wówczas nadaną wartość null.
 */
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
addInitialProduction(S, ProdList, [pr('Z', [nt(S), '#']) | ProdList]).


% createGraph(ListaProdukcji, ListaStanów)
createGraph(ProdList, StateList) :-
  ProdList = [pr('Z', RHS) | _],
  createGraph(ProdList, [ state([pr('Z', [dot | RHS])], []) ], [], StateList).

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
  member(Head, Acc)
  -> expandSituationSet(Tail, ProdList, Acc, ResultSitutationSet)
  ; ( nonterminalAfterDot(Head, S)
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


% createAutomaton(GrafStanów, Automat, Info)
createAutomaton(StateList, Automat, Info) :-
  createAutomaton(StateList, StateList, [], Automat, Info).

% createAutomaton(ListaStanówDoPrzetworzenia, GrafStanów, Akumulator, Automat, Info)
createAutomaton([], _, Acc, Automat, yes) :- reverse(Acc, Automat).
createAutomaton([State | Tail], AllStates, Acc, Automat, Info) :-
  reductionsInState(State, Reductions),
  length(Reductions, ReductionsNumber),
  (
    ReductionsNumber > 1
    -> Automat = null, Info = konflikt("Konflikt reduce-reduce")
    ; (
      length(Acc, StateNumber),
      outgoingEdges(StateNumber, AllStates, OutgoingEdges),
      shiftsInState(OutgoingEdges, Shifts),
      gotosInState(OutgoingEdges, Gotos),
      length(Shifts, ShiftsNumber),
      (
        ( ReductionsNumber =:= 1, ShiftsNumber > 0 )
        -> Automat = null, Info = konflikt("Konflikt shift-reduce")
        ;  createAutomaton(Tail, AllStates, [row(Reductions, Shifts, Gotos) | Acc], Automat, Info)
      )
    )
  ).


% shiftsInState(ListaWychodzącychKrawędzi, ListaShiftów)
shiftsInState(OutgoingEdges, Shifts) :-
  shiftsInState(OutgoingEdges, [], Shifts).

% shiftsInState(ListaKrawędziDoPrzetworzenia, Akumulator, ListaShiftów)
shiftsInState([], Shifts, Shifts).
shiftsInState([ed(S, N) | Tail], Acc, Shifts) :-
  S \= nt(_)
  -> shiftsInState(Tail, [shift(S, N) | Acc], Shifts)
  ;  shiftsInState(Tail, Acc, Shifts).


% gotosInState(ListaWychodzącychKrawędzi, ListaGoto)
gotosInState(OutgoingEdges, Shifts) :-
  gotosInState(OutgoingEdges, [], Shifts).

% gotosInState(ListaKrawędziDoPrzetworzenia, Akumulator, ListaGoto)
gotosInState([], Shifts, Shifts).
gotosInState([ed(S, N) | Tail], Acc, Shifts) :-
  S = nt(_)
  -> gotosInState(Tail, [goto(S, N) | Acc], Shifts)
  ;  gotosInState(Tail, Acc, Shifts).


% outgoingEdges(NumerStanu, GrafStanów, WychodząceKrawędzie)
outgoingEdges(StateNumber, AllStates, OutgoingEdges) :-
  reverse(AllStates, RevStates),
  outgoingEdges(StateNumber, RevStates, [], OutgoingEdges).

% outgoingEdges(NumerStanu, StanyDoPrzetworzenia, Akumulator, WychodząceKrawędzie)
outgoingEdges(_, [], OutgoingEdges, OutgoingEdges).
outgoingEdges(StateNumber, [state(_, InEdges) | Tail], Acc, OutgoingEdges) :-
  length(Tail, DestNumber),
  edgesWithNumber(StateNumber, DestNumber, InEdges, Acc, NewAcc),
  outgoingEdges(StateNumber, Tail, NewAcc, OutgoingEdges).


% edgesWithNumber(NumerŹródła, NumerCelu, KrawędzieDoPrzetworzenia,
%                 Akumulator, PrzefiltrowaneKrawędzie)
edgesWithNumber(_, _, [], FilteredEdges, FilteredEdges).
edgesWithNumber(SrcNumber, DestNumber, [ed(S, N) | Tail], Acc, FilteredEdges) :-
  N =:= SrcNumber
  -> edgesWithNumber(SrcNumber, DestNumber, Tail, [ed(S, DestNumber) | Acc], FilteredEdges)
  ;  edgesWithNumber(SrcNumber, DestNumber, Tail, Acc, FilteredEdges).


% reductionsInState(Stan, MożliweRedukcje)
reductionsInState(State, Reductions) :- reductionsInState(State, [], Reductions).

% reductionsInState(Stan, Akumulator, MożliweRedukcje)
reductionsInState(state([], _), Reductions, Reductions).
reductionsInState(state([pr(S, RHS) | Tail], InEdges), Acc, Reductions) :-
  last(RHS, dot)
  -> (
    delete(RHS, dot, RedRHS),
    reductionsInState(state(Tail, InEdges), [red(S, RedRHS) | Acc], Reductions)
    )
  ;  reductionsInState(state(Tail, InEdges), Acc, Reductions).


/*
 * accept(Automat, Słowo)
 * Sukces wtw, gdy podane Słowo należy do języka generowanego przez
 * gramatykę, dla której został utworzony podany Automat.
 */
accept(Automat, Word) :-
  append(Word, ['#'], WordWithHash),
  check(WordWithHash, [0], Automat).


% check(CzęśćSłowaDoPrzetworzenia, Stos, Automat)
check([], [_, '#' | _], _).
check(Word, Stack, Automat) :-
  Stack = [StateNumber | _],
  nth0(StateNumber, Automat, row(Reductions, Shifts, _)),
  (
    Reductions = [Red]
    -> (
      reduce(Red, Stack, Automat, NewStack),
      check(Word, NewStack, Automat)
    )
    ; (
      Word = [Head | Tail],
      shiftForSymbol(Head, Shifts, ShiftedState),
      check(Tail, [ShiftedState, Head | Stack], Automat)
    )
  ).


% shiftForSymbol(Symbol, ListaShiftów, NowyStan)
shiftForSymbol(Symbol, [shift(S, N) | Tail], ShiftedState) :-
  Symbol == S
  -> N = ShiftedState
  ; shiftForSymbol(Symbol, Tail, ShiftedState).


% gotoForSymbol(Symbol, ListaGoto, NowyStan)
gotoForSymbol(Symbol, [goto(S, N) | Tail], NextState) :-
  Symbol == S
  -> N = NextState
  ; gotoForSymbol(Symbol, Tail, NextState).


% reduce(Redukcja, Stos, Automat, NowyStos)
reduce(red(Symbol, RHS), Stack, Automat, NewStack) :-
  Nt = nt(Symbol),
  reverse(RHS, RevRHS),
  doReduction(RevRHS, Stack, ReducedStack),
  ReducedStack = [StateNumber | _],
  nth0(StateNumber, Automat, row(_, _, Gotos)),
  gotoForSymbol(Nt, Gotos, NextState),
  NewStack = [NextState, Nt | ReducedStack].


% doReduction(CzęśćRedukcjiDoPrzetworzenia, StosDoPrzetworzenia, NowyStos)
doReduction([], ReducedStack, ReducedStack).
doReduction([Symbol | RHSTail], [_, Symbol | StackTail], ReducedStack) :-
  doReduction(RHSTail, StackTail, ReducedStack).