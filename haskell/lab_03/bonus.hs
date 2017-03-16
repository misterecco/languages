module Bonus where

  
import Text.Read
import Data.List(uncons)


readAllIntsMaybe :: [String] -> Maybe [Int]
readAllIntsMaybe input =
  do
    (pierwszy:reszta1) <- return input
    x1 <- readMaybe pierwszy  -- import Text.Read
    (drugi:_) <- return reszta1
    x2 <- readMaybe drugi
    return [x1, x2, x1+x2]

eitherMaybe :: String -> Maybe a -> Either String a
eitherMaybe _ (Just x) = Right x
eitherMaybe s Nothing = Left s


eitherReadMaybe :: Read a => String -> String -> Either String a
eitherReadMaybe s input = eitherMaybe s $ readMaybe input


readAllIntsEither :: [String] -> Either String [Int]
readAllIntsEither input =
  do
    (pierwszy, reszta1) <- eitherMaybe "Brak pierwszej liczby" $ uncons input -- import Data.List
    x1 <- eitherReadMaybe "Pierwsza rzecz to nie liczba" pierwszy
    (drugi, _) <- eitherMaybe "Brak drugiej liczby" $ uncons reszta1
    x2 <- eitherReadMaybe "Druga rzecz to nie liczba" drugi
    return [x1, x2, x1+x2]
