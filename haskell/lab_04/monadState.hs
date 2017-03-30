module MS where

import Control.Monad.Reader
import Control.Monad.State

data Tree a = Empty | Node a (Tree a) (Tree a)


ren :: Tree a -> (Int -> Tree Int)
ren Empty  = return Empty
ren (Node _ s t) = do
  s' <- local (+1) (ren s)
  t' <- local (+1) (ren t)
  \n -> Node n s' t'


ren0 :: Tree a -> (Int -> Tree Int)
ren0 Empty _ = Empty
ren0 (Node _ s t) i =
  let s' = ren0 s ((+1) i) in
  let t' = ren0 t ((+1) i) in
  Node i s' t'


ren2 :: Tree a -> (Int -> Tree Int)
ren2 Empty = return Empty
ren2 (Node _ s t) = do
  i <- ask
  s' <- local (+1) (ren2 s)
  t' <- local (+1) (ren2 t)
  return $ Node i s' t'


-- renumber :: Tree a -> Tree Int
-- renumber t = ren2 t 0


ren3 :: Tree a -> Reader Int (Tree Int)
ren3 Empty = return Empty
ren3 (Node _ s t) = do
  i <- ask
  s' <- local (+1) (ren3 s)
  t' <- local (+1) (ren3 t)
  return $ Node i s' t'


renumber' :: Tree a -> Tree Int
renumber' t = runReader (ren3 t) 0



renumber :: Tree a -> Tree Int
renumber t = evalState (renumbers t) 0

renumbers :: Tree a -> State Int (Tree Int)
renumbers Empty = return Empty
renumbers (Node _ l r) = do
  l' <- renumbers l
  i <- get
  put $ i+1
  r' <- renumbers r
  return $ Node i l' r'


type MojaMonada a = State Int a

renumbers2 :: Tree a -> MojaMonada (Tree Int)
renumbers2 Empty = return Empty
renumbers2 (Node _ l r) = do
  l' <- renumbers l
  i <- gets id
  modify (+1)
  r' <- renumbers r
  return $ Node i l' r'
