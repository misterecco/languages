module ME where

import Data.Char (isHexDigit, digitToInt)
import Control.Monad (foldM)

class Error a where
  noMsg :: a
  strMsg :: String -> a

instance Error String where
  noMsg = "Error"
  strMsg = id

class (Monad m) => MonadError e m | m -> e where
  throwError :: e -> m a
  catchError :: m a -> (e -> m a) -> m a

instance (Error e) => MonadError e (Either e) where
  throwError = Left
  catchError (Left s) f = f s
  catchError (Right s) _ = Right s

-- v4parseHesDigit :: Char -> Either String Int
-- v4parseHesDigit = foldM
--                   (\n c -> do
--                     d <- v4parseHesDigit c
--                     return (16 * n + d))
--                   0

v4toString :: Int -> Either String String
v4toString n =
  if n == 42 then throwError "Haha! 42!"
    else return (show n)


v4convert :: String -> String in
v4convert s = str where
  (Right str) = (do
                  n <- v4parseHex s
                  v4toString n)
                `catchError` error


data ParseError = Err {
  location::Int,
  reason::String
}


instance Error ParseError ...
type ParseMonad = Either ParseError
parseHexDigit :: Char -> Int -> ParseMonad Integer
parseHex :: String -> ParseMonad Integer
toString :: Integer -> ParseMonad String

-- convert zamienia napis z liczba szesnastkowa
--   na napis z liczba dziesietna
convert :: String -> String
convert s = str where
  (Right str) = tryParse s `catchError` printError
  tryParse s = do
    n <- parseHex s
    toString n
  printError e = ...
