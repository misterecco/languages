{-
Module RunAuto
Author: Łukasz Kowalewski

The program will read the input file, split it into lines, and process it line
by line. If any line is found to be incorrect, the program will stop processing
lines and will write "BAD INPUT" to the stdout, followed by the information
describing the error, e.g. the number of the erroneous line.
If the whole input is processed correctly, the program will write "True"
or "False" showing whether the automata accepts the given word.

Some assumptions regarding the input file:
    - the empty lines, or the lines containing whitespace characters only,
      will be ignored,
    - the input with no word description at the end will be considered correct,
      and the empty word will be given to the 'accepts' function of the
      automata.
    - the input with no transitions description will also be considered
      correct - such an automata could be accepting the empty word only.
    - the line containing the word description needs not to be the last line
      of the input - empty lines are allowed to follow.

-}
module Main(main) where

import Control.Monad.State
import System.IO.Error (catchIOError, ioeGetErrorString)
import System.Environment (getArgs)
import Text.Read (readMaybe)
import Data.Char (isDigit, ord, chr, isSpace)
import Data.Monoid (Monoid, mempty, mappend)
import Data.List (find, nub)

import Auto


{-
    The State monad used in the 'main' monad.
    The state (n, cl) describes the total number of states - 'n' - and the
    number of currently processed input line - 'cl'.
-}
type StateIOMonad = StateT (Int, Int) IO

-- the type describing the lists of transitions
data Transition q a = Trans { t :: [(q, a, [q])] } deriving (Show)
instance Monoid (Transition q a) where
    mempty = Trans []
    mappend (Trans t1) (Trans t2) = Trans (t1 ++ t2)

-- the type of the alphabet of the automata
newtype Alpha = Alpha Char deriving (Eq)

instance Bounded Alpha where
    minBound = Alpha 'A'
    maxBound = Alpha 'Z'

instance Show Alpha where
    show (Alpha a) = show a

instance Enum Alpha where
    toEnum n = let (Alpha a) = minBound in
        Alpha (chr $ (ord a) + n)
    fromEnum (Alpha a) = let (Alpha a') = minBound in
        (ord a) - (ord a')

type TransInt = Transition Int Alpha

-- Checks whether the character fits into the bounds of the Alpha type
isUpperAlpha :: Char -> Bool
isUpperAlpha c = n >= minA && n <= maxA where
    n = ord c
    minA = let (Alpha a) = minBound :: Alpha in ord a
    maxA = let (Alpha a) = maxBound :: Alpha in ord a

-- Joins the text with the line number
joinLineNum :: String -> Int -> String
joinLineNum s cl = s ++ " (line " ++ (show cl) ++ ")"

-- Increases the counter in the state
increaseCount :: StateIOMonad ()
increaseCount = modify f where
    f (n, cl) = (n, cl + 1)

-- Decreases the counter in the state
decreaseCount :: StateIOMonad ()
decreaseCount = modify f where
    f (n, cl) = (n, cl - 1)

-- returns True iff the argument has 0 length or contains space characters only
isEmptyLine :: String -> Bool
isEmptyLine l = l == [] || all isSpace l

{-
    Tries to read the first non-empty string in the list and returns
    the obtained value or lifts 'fail', reporting an error.
    Skips empty lines.
    If the function reaches the end of input it reports an error.
-}
readLines :: Read a => [String] -> StateIOMonad a
readLines [] = liftIO $ fail "unexpected end of input"
readLines (l:ls)= do
    -- increase the current line number
    increaseCount
    if isEmptyLine l
        then readLines ls
        else do
            -- get the current line number
            (_, cl) <- get
            let n = (readMaybe l)
            -- if the read is unsuccessful lift 'fail'
            case n of
                Just n -> return n
                Nothing -> liftIO $ fail $ joinLineNum l cl

{-
    Tries to read the word description in the current line of input.
    If the word description contains an error, which is when either:
      - the line contains more than one word,
      - the word contains forbidden character,
    the function lifts 'fail'.
-}
readWord :: [String] -> StateIOMonad [Alpha]
readWord ls = do
    -- get the current line number
    (n, cl) <- get
    -- increase count
    put (n, cl + 1)
    -- get the current line
    let l = ls !! cl
    -- split into words
    let s = words l
    -- check correctness
    if (length s > 1) || (any (not . isUpperAlpha) (head s))
        then liftIO $ fail $ joinLineNum l (cl + 1)
        else return $ map (\c -> Alpha c)(head s)

{-
    Gets the total number of states n, the number of a current state and
    returns True iff the state number is not between 1 and n.
-}
isBadState :: Int -> Int -> Bool
isBadState n state = state > n || state <= 0

-- The same as isBadState but accepts Maybe Int as the number of current state.
isBadMaybe :: Int -> Maybe Int -> Bool
isBadMaybe n Nothing = True
isBadMaybe n (Just s) = isBadState n s

{-
    Checks if every state in the list is correct. If there is any state that
    is not allowed, function lifts 'fail', reporting the first wrong state
    and the current line of input.
-}
checkStateCorrectness :: [Int] -> StateIOMonad ()
checkStateCorrectness states = do
    (n, cl) <- get
    let badState = find (isBadState n) states
    case badState of
         Just s -> liftIO $ fail $ joinLineNum ("wrong state: " ++ (show s)) cl
         Nothing -> return ()

{-
    Gets the state number, the list of letters, and the list of reachable
    states, and returns transition. The result will be the list of the same
    length as the count of unique letters in the second argument.
-}
getTransition :: Maybe Int -> String -> [Maybe Int] -> TransInt
getTransition Nothing _ _ = mempty
getTransition (Just s) w ts = Trans $ map mapLetter (nub w) where
    ts' = [t | Just t <- ts]
    mapLetter c = (s, Alpha c, ts')

{-
    Tries to read all transitions from a single line.
    The line should contain at least two words - the first word as the number
    of the state, the second word as the list of letters for the transitions.
    The other words are the numbers of reachable states.
    If the line contains less then two words, then the returned value will be
    Nothing, suggesting that there might be a word description in this line.
-}
readTransitionMaybe :: String -> StateIOMonad (Maybe TransInt)
readTransitionMaybe t = do
    let ws = words t
    if length ws < 2
        then return Nothing
        else do
            let s = (readMaybe $ head ws) :: Maybe Int
            let ls = ws !! 1
            let ts = map readMaybe $ drop 2 ws :: [Maybe Int]
            (n, cl) <- get
            -- liftIO $ putStrLn $ joinLineNum (show ws) cl
            if (any (isBadMaybe n) $ ts ++ [s]) || any (not . isUpperAlpha) ls
                then liftIO $ fail $ joinLineNum t cl
                else return $ Just (getTransition s ls ts)

{-
    Tries to read transitions descriptions until either:
     - encounters line containing wrong description - lifts 'fail'
     - encounters line with less than 2 words - such line is
       treated as either a word description or an error - it will be
       checked later in 'readWord' function.
     - gets to the end of the input - such a situation will be treated as
       the end of automata description, and the word to check will be an
       empty word, therefore no error is reported.
-}
readTransitions :: [String] -> StateIOMonad TransInt
readTransitions [] = return mempty
readTransitions (t:ts) = do
    increaseCount
    if isEmptyLine t
        then readTransitions ts
        else do
            t' <- readTransitionMaybe t
            case t' of
                Nothing -> do
                    -- possibly the word definition in this line
                    decreaseCount
                    return mempty
                Just t -> do
                    ts' <- readTransitions ts
                    return $ mappend t ts'

{-
    Reads the whole input and returns the tuple:
    (number of states, initial states, accepting states, transitions, word)
    Keeps the count of the already read lines in the state and the total number
    of states. If any line is found to be incorrect, the 'fail' function is
    lifted, with the information of the number of line in which the error was
    found.
    Empty lines are ignored. Only the first three lines are necessary -
    the states definition with the initial and accepting states.
    If there is no word in the input the automata will be given an empty word
    to check.
    If, after the line containing the word description, there is any non-empty
    line found, the whole input is incorrect, and the 'fail' is lifted.
-}
readInput :: [String] -> StateIOMonad (Int, [Int], [Int], TransInt, [Alpha])
readInput [] = liftIO $ fail "no input"
readInput ls = do
    n <- readLines ls :: StateIOMonad Int
    (_, cl) <- get
    put (n, cl)
    n2 <- (readLines $ drop cl ls) :: StateIOMonad [Int]
    checkStateCorrectness n2
    (_, cl) <- get
    n3 <- (readLines $ drop cl ls) :: StateIOMonad [Int]
    checkStateCorrectness n3
    (_, cl) <- get
    n5 <- readTransitions $ drop cl ls
    (_, cl) <- get
    -- if the input is over then we have an empty word to check
    w <- if cl >= length ls
        then return []
        else readWord ls
    (_, cl) <- get
    -- check that there is no input left
    if not $ all isEmptyLine (drop cl ls)
       then liftIO $ fail $ joinLineNum "extra input after word definition" cl
       else return (n, n2, n3, n5, w)

-- Creates the automata
makeAuto :: [Int] -> [Int] -> [Int] -> TransInt -> Auto Alpha Int
makeAuto sts (iSts) (aSts)  ((Trans ts)) = fromLists sts iSts aSts ts

-- Checks that there is only one argument given, else calls 'fail'
checkArgs :: [String] -> IO ()
checkArgs args = if length args == 1
                    then return ()
                    else fail "wrong number of arguments"

main = catchIOError ( do
        args <- getArgs
        checkArgs args
        let path = args !! 0
        f <- readFile path
        -- splits into lines
        let l = lines f
        (n, initSts, accSts, transitions, w) <- evalStateT (readInput l) (0, 0)
        let a = makeAuto [1 .. n] initSts accSts transitions
        -- possibly print automata and the word
        -- print a
        -- print w
        print $ accepts a w
    ) (\e -> putStrLn $ "BAD INPUT\n" ++ (ioeGetErrorString e) )
