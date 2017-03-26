import           Auto
import           System.Environment
import           Text.Read

-- TODO: fix parsing of transition

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
readAlphas [] = Nothing
readAlphas alps = mapM readAlpha alps


readMaxState :: String -> Maybe Int
readMaxState = readMaybe

readState :: Int -> String -> Maybe State
readState maxState st = do
  state <- readMaybe st
  let allStates = [1..maxState]
  if state `elem` allStates then return state else Nothing

readStates :: Int -> String -> Maybe [State]
readStates maxState st = mapM (readState maxState) (words st)

readStatesList :: Int -> String -> Maybe [State]
readStatesList maxState st = do
  states <- readMaybe st
  let allStates = [1..maxState]
  if all (`elem` allStates) states then return states else Nothing

readTransition :: Int -> String -> Maybe [(State, Alpha, [State])]
readTransition maxState ln = do
  (st:chars:dests) <- Just $ words ln
  state <- readState maxState st
  letters <- readAlphas chars
  destinationStates <- readStates maxState $ unwords dests
  return [(state, letter, destinationStates) | letter <- letters]


runAuto :: String -> Maybe Bool
runAuto input = do
  (maxSt:initSt:acceptSt:rest) <- splitLines input
  maxState <- readMaxState maxSt
  initialStates <- readStatesList maxState initSt
  acceptingStates <- readStatesList maxState acceptSt
  let (trans, [w]) = splitAtLast rest
  let transitions = concat $ mapM (concat . readTransition maxState) trans
  word <- readAlphas w
  let auto = fromLists [1..maxState] initialStates acceptingStates transitions
  return $ accepts auto word


splitLines :: String -> Maybe [String]
splitLines input = Just $ filter (not . null) (lines input)

splitAtLast :: [a] -> ([a], [a])
splitAtLast ls = splitAt (n-1) ls
  where n = length ls


main :: IO ()
main = do
  (filename:_) <- getArgs
  contents <- readFile filename
  let result = runAuto contents
  case result of
    Nothing -> putStrLn "BAD INPUT"
    Just r  -> print r
