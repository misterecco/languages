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


% ?- productionList(pl1, PL), initialProd(p1, P), expandSituationSet([P], PL, EP).
% ?- productionList(pl1, PL), initialProd(p1, P), expandSituationSet([P], PL, EP), printList(EP).

% ?- productionList(pl1, PL), createSituationSets(PL, SS), printListOfLists(SS).