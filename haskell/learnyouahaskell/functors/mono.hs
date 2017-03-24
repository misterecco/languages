module Mono where

import Data.Monoid hiding (First)

lengthCompare :: String -> String -> Ordering
lengthCompare x y = (length x `compare` length y) `mappend` (x `compare` y)

-- instance Monoid a => Monoid (Maybe a) where
--   mempty = Nothing
--   Nothing `mappend` m = m
--   m `mappend` Nothing = m
--   Just m1 `mappend` Just m2 = Just (m1 `mappend` m2)

newtype First a = First { getFirst :: Maybe a }
  deriving (Eq, Ord, Read, Show)

instance Monoid (First a) where
  mempty = First Nothing
  First (Just x) `mappend` _ = First (Just x)
  First Nothing `mappend` x = x
