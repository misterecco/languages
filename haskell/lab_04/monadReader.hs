module R where

import Control.Monad.Reader


data Tree a = Empty | Node a (Tree a) (Tree a)
  deriving (Eq, Ord, Show)

renumber' :: Tree a -> Tree Int
renumber' x = foo x 0 where
  foo Empty _ = Empty
  foo (Node _ lt rt) n = Node n (foo lt (n+1)) (foo rt (n+1))


ren :: Tree a -> Reader Int (Tree Int)
ren Empty = return Empty
ren (Node _ l r) = do
  n <- ask
  lt <- local (+1) (ren l)
  rt <- local (+1) (ren r)
  return $ Node n lt rt


renumber :: Tree a -> Tree Int
renumber t = runReader (ren t) 0

tr :: Tree Int
tr = Node 10 (Node 15 (Node 20 Empty Empty) Empty) Empty


type Var = String

data Exp
  = EInt Int
  | EOp Op Exp Exp
  | EVar Var
  | ELet Var Exp Exp

data Op = OpAdd | OpMul | OpSub

evalExp :: Exp -> Int
-- TODO
evalExp = const 0

-- eval :: Exp -> Reader Int (Exp)
-- eval
