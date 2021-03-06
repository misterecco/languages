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

prodList(pl2, [
        prod(`Z`, [
            [nt(`F`), `#`]
        ]),
        prod(`F`, [
            [`(`, nt(`L`), `)`]
        ]),
        prod(`L`, [
            [nt(`L`), nt(`E`)],
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


% ?- productionList(pl1, PL), initialProd(p1, P), expandSituationSet([P], PL, EP).
% ?- productionList(pl1, PL), initialProd(p1, P), expandSituationSet([P], PL, EP), printList(EP).

% ?- productionList(pl1, PL), createGraph(PL, SS), createAutomaton(SS, Automat, Info).