/*
 * Reprezentacja (termowa) drzew binarnych:
 *    nil                  - drzewo puste
 *    tree(Lewe, W, Prawe) - drzewo niepuste
 */


/*
 * drzewo(D) == D jest drzewem binarnym
 */
drzewo(nil).
drzewo(tree(Lewe, _, Prawe)) :- drzewo(Lewe),
                                drzewo(Prawe).

/*
 * ileW(D, K) == drzewo binarne D składa się z K wierzchołków
 */
ileW(D, K) :- ileW(D, 0, K).

ileW(nil, A, A).
ileW(tree(Lewe, _, Prawe), A, X) :- AN is A + 1,
                                    ileW(Prawe, AN, XP),
                                    ileW(Lewe, XP, X).
