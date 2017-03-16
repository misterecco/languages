module Zad_02 where

import Prelude hiding(Either(..))
data Either a b = Left a | Right b

instance Functor (Either e) where
  -- fmap :: (a -> b) -> Either e a -> Either e b
  fmap _ (Left e) = Left e
  fmap f (Right a) = Right (f a)
