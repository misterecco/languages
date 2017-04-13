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
evalExp e = runReader (eval e) (const undefined)

eval :: Exp -> Reader (Var -> Maybe Int) Int
eval (EInt x) = return x

eval (EVar var) = do
  env <- ask
  case env var of
    Nothing -> undefined
    Just x -> return x

eval (EOp op e1 e2) = do
  x1 <- eval e1
  x2 <- eval e2
  case op of
    OpAdd -> return (x1 + x2)
    OpMul -> return (x1 * x2)
    OpSub -> return (x1 - x2)

eval (ELet var e1 e2) = do
  x1 <- eval e1
  local (\f x -> if x == var then Just x1 else f x) (eval e2)


test :: Exp
test = ELet "x" (ELet "y" (EOp OpAdd (EInt 6) (EInt 9))
                      (EOp OpSub y (EInt 1)))
                (EOp OpMul x (EInt 3))
    where x = EVar "x"
          y = EVar "y"
