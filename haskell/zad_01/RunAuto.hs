module RunAuto where

import Auto
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
  toEnum x = Alpha (toEnum x)
  fromEnum (Alpha x) = fromEnum x
  succ (Alpha x) = Alpha (succ x)
  pred (Alpha x) = Alpha (pred x)

allAlphas :: [Alpha]
allAlphas = [minBound..maxBound]

isAlpha :: Char -> Bool
isAlpha = (`elem` ['A'..'Z'])

readAlpha :: Char -> Maybe Alpha
readAlpha x = if isAlpha x then Just (Alpha x) else Nothing

readAlphas :: String -> Maybe [Alpha]
readAlphas = mapM readAlpha

readStatesCount :: String -> Maybe Int
readStatesCount = readMaybe

readState :: String -> Maybe State
readState = readMaybe

-- TODO: check if state is in the range
readStates :: String -> Maybe [State]
readStates l = mapM readState (words l)

readInitStates :: String -> Maybe [State]
readInitStates = readMaybe

readAcceptingStates :: String -> Maybe [State]
readAcceptingStates = readMaybe

readTransition :: String -> Maybe [(State, Alpha, [State])]
readTransition ln = do
  (s:cs:dsts) <- Just $ words ln
  state <- readState s
  letters <- readAlphas cs
  destinationStates <- readStates $ unwords dsts
  return [(state, letter, destinationStates) | letter <- letters]

readWord :: String -> Maybe String
readWord [] = Nothing
readWord w = Just w

runAuto :: String -> Maybe Bool
runAuto input = do
  (nos:inSt:accSt:trans) <- splitLines input
  statesCount <- readStatesCount nos
  inSt <- readInitStates inSt
  accSt <- readAcceptingStates accSt
  let (tr, word) = splitAtLast trans
  let t = concat $ mapM (concat . readTransition) tr
  let a = fromLists [1..statesCount] inSt accSt t
  return $ accepts a word

splitLines :: String -> Maybe [String]
splitLines input = Just $ filter (not . null) (lines input)

splitAtLast :: [a] -> ([a], [a])
splitAtLast ls = let n = length ls in splitAt (n-1) ls

-- main :: IO ()
-- main = do
--   (filename:args) <- getArgs
--   putStrLn $ "Reading from file named: " ++ filename
