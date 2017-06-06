printList([]).
printList([H | T]) :-
  print(H),
  nl,
  printList(T).