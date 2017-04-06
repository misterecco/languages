module P where

import Data.Ratio
import Control.Arrow

newtype Prob a = Prob { getProb :: [(a, Rational)] } deriving Show

instance Functor Prob where
  fmap f (Prob xs) = Prob $ map (first f) xs


flatten :: Prob (Prob a) -> Prob a
flatten (Prob xs) = Prob $ concatMap multAll xs
  where multAll (Prob innerxs, p) = map (second (*p)) innerxs


instance Monad Prob where
  return x = Prob [(x, 1 % 1)]
  m >>= f = flatten (fmap f m)
  fail _ = Prob []
