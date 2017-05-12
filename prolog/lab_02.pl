% scal(L1, L2, L3) iff L1 * L2 = L3

scal([], L, L).
scal([H | T], L1, [H | L]) :- scal(T, L1, L).


% intersect(S1, S2) iff S1 intersected with S2 is not null
intersect([H | _], L) :- member(H, L).
intersect([_ | T], L) :- intersect(T, L).


% podziel(List, SubListOdd, SubListEven)
podziel([H | T], [H | TO], E) :- podziel(T, E, TO).
podziel([], [], []).


% podlista(P, L)
podlista([], []).
podlista([], [_ | _]).
podlista().


% podciag(P, L)
podciag([], []).
podciag([H | TP], [H | TL]) :- podciag(TP, TL).
podciag(P, [_ | TL]) :- podciag(P, TL).
