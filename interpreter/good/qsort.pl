partition([], _, [], []).
partition([H | T], E, [H | LL], LP) :- H =< E,
                                       partition(T, E, LL, LP).
partition([H | T], E, LL, [H | LP]) :- H > E,
                                       partition(T, E, LL, LP).

% qsort(L, S) iff S is sorted list L
qsort(L, S) :- qsort(L, [], S).
qsort([], A, A).
qsort([E | L], A, S) :- partition(L, E, LL, LP),
                        qsort(LP, A, PS),
                        qsort(LL, [E | PS], S).

?- qsort([3, 7, 6, 5, 8, 1, 4, 2], L).
