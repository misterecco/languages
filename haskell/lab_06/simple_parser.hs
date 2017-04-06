module SP where

-- run (spaces >> pNat) " 123"

import Text.ParserCombinators.Parsec
import Data.Char (digitToInt)

-- type Parser a = GenParser Char () a
-- parse :: GenParser tok () a -> SourceName -> [tok]
-- -> Either ParseError a

pDigit :: Parser Int
pDigit = fmap digitToInt digit

pDigits :: Parser [Int]
pDigits = many1 pDigit

pInt :: Parser Integer
pInt = pNat <|> negative pNat where
  negative :: (Num a) => Parser a -> Parser a
  negative p = fmap negate (char '-' >> p)

pNat :: Parser Integer
pNat = fmap (foldl (\x y -> 10*x+toInteger y) 0) pDigits

run :: Parser a -> String -> Either ParseError a
run p = parse p "(interactive)"
