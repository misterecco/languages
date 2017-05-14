/*
 *  Term representation of binary trees:
 *    nil                  - empty tree
 *    tree(Left, Value, Right) - non-empty tree
 */


% isTree(D) iff D is a binary tree
isTree(nil).
isTree(tree(L, _, R)) :- isTree(L),
                         isTree(R).

?- isTree(nil).
?- isTree(tree(tree(nil, 1, nil), 2, nil)).


% nodeCount(D, K) iff binary tree D consists of K nodes
nodeCount(D, K) :- nodeCount(D, 0, K).

nodeCount(nil, A, A).
nodeCount(tree(L, _, R), A, X) :- AN is A + 1,
                                  nodeCount(L, AN, XP),
                                  nodeCount(R, XP, X).

?- nodeCount(nil, X).
?- nodeCount(tree(tree(nil, 1, nil), 2, nil), X).


% insertBST(D, E, N) iff N  is a binary search tree created by adding E to D
insertBST(nil, E, tree(nil, E, nil)).
insertBST(tree(LT, W, RT), E, tree(LNT, W, RT)) :- E =< W,
                                                   insertBST(LT, E, LNT).
insertBST(tree(LT, W, RT), E, tree(LT, W, RNT)) :- E > W,
                                                   insertBST(RT, E, RNT).

?- insertBST(nil, 1, T).
?- insertBST(nil, 1, T), insertBST(T, 2, T2).

/*
 * createBST(L, D) iff D is a BST containing all values from L list
 */
createBST(L, D) :- createBST(L, nil, D).

createBST([], D, D).
createBST([H | T], A, D) :- insertBST(A, H, AN),
                            createBST(T, AN, D).

?- createBST([3,1,5,2,0], T).

% toList(D, L) iff L - list contating all elements of tree D (infix)
toList(D, L) :- toList(D, [], L).

toList(nil, L, L).
toList(tree(LT, W, RT), A, L) :- toList(RT, A, AR),
                                    toList(LT, [W | AR], L).

?- createBST([3,1,5,2,0], T), toList(T, L).

% sortBST(L, S) iff S if sorted L
sortBST(L, S) :- createBST(L, D), toList(D, S).

?- sortBST([7,5,3,2,1,10,4], S).
