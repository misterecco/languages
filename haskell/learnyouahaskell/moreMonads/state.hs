module S where

import System.Random
import Control.Monad.State

type Stack = [Int]

pop :: Stack -> (Int, Stack)
pop (x:xs) = (x, xs)
pop [] = error "Empty stack"

push :: Int -> Stack -> ((), Stack)
push a xs = ((), a:xs)


stackManip :: Stack -> (Int, Stack)
stackManip stack = let
  ((), newStack1) = push 3 stack
  (_, newStack2) = pop newStack1
  in pop newStack2


-- newtype State s a = State { runState :: s -> (a, s) }

-- instance Monad (State s) where
--   return x = State $ \s -> (x, s)
--   (State h) >>= f = State $ \s -> let (a, newState) = h s
--                                       (State g) = f a
--                                       in g newState

pop' :: State Stack Int
pop' = state $ \(x:xs) -> (x, xs)

push' :: Int -> State Stack ()
push' a = state $ \xs -> ((), a:xs)

stackManip' :: State Stack Int
stackManip' = do
  push' 3
  _ <- pop'
  pop'


-- get = State $ \s -> (s, s)
-- put newState = State $ \x -> ((), newState)


randomSt :: (RandomGen g, Random a) =>  State g a
randomSt = state random

threeCoins :: State StdGen (Bool, Bool, Bool)
threeCoins = do
  a <- randomSt
  b <- randomSt
  c <- randomSt
  return (a, b, c)
