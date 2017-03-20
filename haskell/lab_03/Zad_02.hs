module Zad_02 where

import Prelude hiding(Either(..))
data Either a b = Left a | Right b
  deriving (Show)

instance Functor (Either e) where
  -- fmap :: (a -> b) -> Either e a -> Either e b
  fmap _ (Left e) = Left e
  fmap f (Right a) = Right (f a)

reverseRight :: Either e [a] -> Either e [a]
-- reverseRight (Left e) = Left e
-- reverseRight (Right l) = Right $ reverse l

reverseRight = fmap reverse
-- reverseRight x = reverse <$> x


class Functor f => Pointed f where
  pure :: a -> f a

-- instance Pointed [] where
  -- pure x = repeat x

instance Pointed [] where
  pure x = [x]

instance Pointed Maybe where
  pure x = Just x

-- instance Pointed Tree where
  -- pure x = Node x Empty Empty
