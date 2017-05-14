% length(L, K) iff list L consists of K elements
length(L, K) :- length(L, 0, K).
length([], K, K).
length([_ | Tail], A, K) :- AT is A + 1,
                            length(Tail, AT, K).

?- length([1,2,3,4,5], K).
?- length("prolog", K).

% sum(L, S) iff S is a sum of elements of L
sum(L, S) :- sum(L, 0, S).
sum([], S, S).
sum([X | Tail], A, S) :- AT is A + X,
                         sum(Tail, AT, S).

?- sum([1,2,3,4,5,6,7,8,9,10], S).

% fib(K, N) iff N is K-th Fibonacci number
fib(K, N) :- fib(K, 0, 0, 1, N).

% X - index, FX = X-th Fibonacci number
% FX1 - (X-1)-th Fibonacci number
fib(X, X, FX, _, FX).
fib(K, X, FX, FX1, N) :- X < K,
                         X1 is X + 1,
                         FX2 is FX + FX1,
                         fib(K, X1, FX1, FX2, N).

?- fib(10, N).
?- fib(11, N).
?- fib(12, N).
