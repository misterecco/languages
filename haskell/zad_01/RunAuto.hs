module RunAuto where

import System.Environment
import Text.Read
-- import Control.Monad

-- liftM :: (Monad m) => (a -> b) -> m a -> m b

type State = Int

newtype Alpha = Alpha Char
  deriving (Eq, Show)

instance Bounded Alpha where
  minBound = Alpha 'A'
  maxBound = Alpha 'Z'

instance Enum Alpha where
  toEnum = toEnum
  fromEnum = fromEnum

readAlpha :: String -> Maybe Alpha
readAlpha [x] = Just $ Alpha x
readAlpha _ = Nothing

readStatesCount :: String -> Maybe Int
readStatesCount = readMaybe

readState :: String -> Maybe State
readState = readMaybe

flattenMaybe :: [Maybe a] -> Maybe [a]
flattenMaybe l = foo l [] where
  foo [] acc = Just $ reverse acc
  foo (Nothing:_) _ = Nothing
  foo (Just x : xs) acc = foo xs (x : acc)

readStates :: String -> Maybe [State]
readStates l = do
  states <- flattenMaybe $ map readState (words l)
  Just states

readInitStates :: String -> Maybe [State]
readInitStates = readStates

readAcceptingStates :: String -> Maybe [State]
readAcceptingStates = readStates


-- TODO: handle a case like this: 1 AB 1 (mutliple letters)
readTransition :: String -> Maybe [(State, Alpha, [State])]
readTransition l = do
  (s:cs:dsts) <- Just $ words l
  state <- readState s
  letters <- readAlpha cs
  destinationStates <- readStates $ unwords dsts
  return [(state, letters, destinationStates)]

-- readSth :: String -> Maybe (String, String, [String])
-- readSth l = do
--   (a:b:cs) <- Just $ words l
--   return (a, b, cs)

readWord :: String -> Maybe String
readWord [] = Nothing
readWord w = Just w

-- runAuto :: [String] -> Maybe Bool
-- -- runAuto lines =


-- main :: IO ()
-- main = do
--   (filename:args) <- getArgs
--   putStrLn $ "Reading from file named: " ++ filename
