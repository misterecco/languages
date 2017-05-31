printList([]).
printList([H | T]) :- 
  write(H),   
  nl, 
  printList(T).

printListOfLists([]) :- write("======\n").
printListOfLists([H | T]) :-
  write("------\n"),
  printList(H),
  printListOfLists(T).