module RunAuto where

import           Auto
import           Control.Monad
import           Data.List          (find, nub)
import           System.Environment
import           Text.Read


-- TODO: try using liftM
-- TODO: better naming, formatting and styling
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

isAlpha :: Char -> Bool
isAlpha = (`elem` ['A'..'Z'])

readAlpha :: Char -> Maybe Alpha
readAlpha x = if isAlpha x then Just (Alpha x) else Nothing

readAlphas :: String -> Maybe [Alpha]
readAlphas = mapM readAlpha


readStatesCount :: String -> Maybe Int
readStatesCount = readMaybe

readState :: Int -> String -> Maybe State
readState maxState x = do
  s <- readMaybe x
  let allStates = [1..maxState]
  if s `elem` allStates then return s else Nothing

readStates :: Int -> String -> Maybe [State]
readStates maxState l = mapM (readState maxState) (words l)

readStatesList :: Int -> String -> Maybe [State]
readStatesList maxState x = do
  sl <- readMaybe x
  let allStates = [1..maxState]
  if all (`elem` allStates) sl then return sl else Nothing

readAcceptingStates ::  String -> Maybe [State]
readAcceptingStates = readMaybe

readTransition :: Int -> String -> Maybe [(State, Alpha, [State])]
readTransition maxState ln = do
  (s:cs:dsts) <- Just $ words ln
  state <- readState maxState s
  letters <- readAlphas cs
  destinationStates <- readStates maxState $ unwords dsts
  return [(state, letter, destinationStates) | letter <- letters]

readWord :: String -> Maybe [Alpha]
readWord [] = Nothing
readWord w  = if all (`elem` ['A'..'Z']) w then Just (fmap Alpha w) else Nothing

runAuto :: String -> Maybe Bool
runAuto input = do
  (nos:inSt:accSt:trans) <- splitLines input
  statesCount <- readStatesCount nos
  initSt <- readStatesList statesCount inSt
  acceptingSt <- readStatesList statesCount accSt
  let (tr, [word]) = splitAtLast trans
  let t = concat $ mapM (concat . readTransition statesCount) tr
  let a = fromLists [1..statesCount] initSt acceptingSt t
  aWord <- readWord word
  return $ accepts a aWord

splitLines :: String -> Maybe [String]
splitLines input = Just $ filter (not . null) (lines input)

splitAtLast :: [a] -> ([a], [a])
splitAtLast ls = let n = length ls in splitAt (n-1) ls


main :: IO ()
main = do
  (filename:_) <- getArgs
  contents <- readFile filename
  let result = runAuto contents
  case result of
    Nothing -> putStrLn "BAD INPUT"
    Just r  -> print r
