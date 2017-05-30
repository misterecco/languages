/*
 * Tomasz Kępa <tk359746@students.mimuw.edu.pl>
 * Zadanie 2 JPP - prolog
 */

% :- use_module(library(lists)).

/*
 * createLR(+Gramatyka, -Automat, -Info)
 *
 * Dla podanej gramatyki tworzy automat LR(0). W przypadku utworzenia
 * automatu parametr Info powinien mieć nadaną wartość yes,
 * a w przeciwnym przypadku jego wartością powinien być term
 * konflikt(Opis), gdzie Opis jest (czytelnym) opisem rozpoznanego
 * konfliktu, a parametr Automat powinien mieć wówczas nadaną wartość
 * null.
 */

% gramatyka(SymbolPoczatkowy, ZbiorProdukcji).
% prod(NazwaNieterminala, ListaPrawychStronProdukcji)
% nt(Nieterminal)

% expandGrammar(Gramatyka, RozszerzonaListaProdukcji)
% createSituationSets(ListaProdukcji, ZbiorySytuacjiLR)
% createAutomaton(ZbiorySytuacjiLR, Automat, Info)
% createSituationSet(ListaProdukcji, PoczątkoweSytuacje, ZbiórSytuacjiLR)

% transition(Symbol, NumerSytuacji)
% situationSet(Produkcje, Przejścia)
% automat(ListaProdukcji, TabelaActionGoTo)

createLR(Grammar, Automat, Info) :- expandGrammar(Grammar, ProductionList),
                                    createSituationSets(ProductionList, SituationSets),
                                    createAutomaton(SituationSets, Automat, Info).

expandGrammar(gramatyka(SP, ZP), [prod(nt(`Z`), [ [SP, `#`] ]) | ZP]).

createSituationSets([ prod(SP, []) | Tail ], Automat, Info) :- createSituations(Tail, Automat, Info).

expandSituationSet()


/*
 * accept(+Automat, +Słowo)
 *
 * Sukces wtw, gdy podane Słowo należy do języka generowanego przez
 * gramatykę, dla której został utworzony podany Automat.
 */

accept(_, _) :- true.
