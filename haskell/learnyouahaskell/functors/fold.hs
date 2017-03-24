module Fold where

import qualified Data.Foldable as F

data Tree a = Empty | Node a (Tree a) (Tree a)
  deriving (Show, Read, Eq)


-- foldMap :: (Monoid m, Foldable t) => (a -> m) -> t a -> m
instance F.Foldable Tree where
  foldMap _ Empty = mempty
  foldMap f (Node x l r) = F.foldMap f l `mappend` f x `mappend` F.foldMap f r

testTree :: Tree Int
testTree = Node 5
            (Node 3
                (Node 1 Empty Empty)
                (Node 6 Empty Empty)
            )
            (Node 9
                (Node 8 Empty Empty)
                (Node 10 Empty Empty)
            )
