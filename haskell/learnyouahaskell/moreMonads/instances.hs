module I where

import Control.Monad.Instances

-- instance Monad ((->) r) where
--   return x = \_ -> x
--   h >>= f = \w -> f (h w) w


addStuff :: Int -> Int
addStuff = do
  a <- (*2)
  b <- (+10)
  return (a+b)
