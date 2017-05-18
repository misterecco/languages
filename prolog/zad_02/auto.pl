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

% createLR(_, automat, yes).
createLR(_, null, konflikt("Not implemented")).

/*
 * accept(+Automat, +Słowo)
 *
 * Sukces wtw, gdy podane Słowo należy do języka generowanego przez
 * gramatykę, dla której został utworzony podany Automat.
 */

accept(_, _) :- true.
