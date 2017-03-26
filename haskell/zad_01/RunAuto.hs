import           Auto
import           System.Environment
import           System.IO.Error
import           Text.Read

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
readStates _ [] = Nothing
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

readWord :: [String] -> Maybe [Alpha]
readWord st =
  if length st /= 1
    then Nothing
    else readAlphas $ head st


runAuto :: String -> Maybe Bool
runAuto input = do
  (maxSt:initSt:acceptSt:rest) <- splitLines input
  maxState <- readMaxState maxSt
  initialStates <- readStatesList maxState initSt
  acceptingStates <- readStatesList maxState acceptSt
  (trans, w) <- splitAtLast rest
  let transMapped = map (readTransition maxState) trans
  transitions <- concat <$> sequence transMapped
  word <- readWord w
  let auto = fromLists [1..maxState] initialStates acceptingStates transitions
  return $ accepts auto word


splitLines :: String -> Maybe [String]
splitLines input = Just $ filter (not . null) (lines input)

splitAtLast :: [a] -> Maybe ([a], [a])
splitAtLast [] = Nothing
splitAtLast ls = Just $ splitAt (n-1) ls
  where n = length ls


processFile :: String -> IO ()
processFile fileName = do
  contents <- readFile fileName
  let result = runAuto contents
  case result of
    Nothing -> putStrLn "BAD INPUT"
    Just r  -> print r


handler :: IOError -> IO ()
handler e
  | isDoesNotExistError e = case ioeGetFileName e of
    Just path -> putStrLn $ "BAD INPUT (file " ++ path ++ " does not exist)"
    Nothing -> putStrLn "BAD INPUT (file does not exist at unknown location!)"
  | otherwise = ioError e


main :: IO ()
main = do
  args <- getArgs
  case length args of
    0 -> print "BAD INPUT (file name not provided)"
    1 -> processFile (head args) `catchIOError` handler
    _ -> print "BAD INPUT (too many arguments)"
