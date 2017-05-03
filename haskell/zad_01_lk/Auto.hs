{-
Module Auto
Author: Łukasz Kowalewski
-}

module Auto (
    Auto,
    accepts,
    emptyA,
    epsA,
    symA,
    leftA,
    sumA,
    thenA,
    fromLists,
    toLists
) where

import Data.List (nub, intercalate)

data Auto a q = A {
    states      :: [q],
    initStates  :: [q],
    isAccepting :: q -> Bool,
    transition  :: q -> a -> [q]
}

{-
    Checks if the automata aut accepts the word w.
    Calls recursive function 'acceptsFrom' and passes to it all initial states.
    'acceptsfrom', at each call, creates a set of unique states that are
    reachable from any of the current states with the current letter,
    and calls recursively 'acceptsfrom' with the new set of states and the
    tail of the initial word
-}
accepts :: Eq q => Auto a q -> [a] -> Bool
accepts aut w = acceptsFrom aut w (initStates aut) where
    acceptsFrom :: Eq q => Auto a q -> [a] -> [q] -> Bool
    acceptsFrom aut [] sts = any (isAccepting aut) sts
    acceptsFrom aut (w:ws) sts = let
       trans = (\s -> transition aut s w)
       reachableStates = nub (foldr (++) [] (map trans sts)) 
                                 in (acceptsFrom aut ws) reachableStates
-- Automata for empty language - no states
emptyA :: Auto a ()
emptyA = A [] [] (\_ -> False) (\_ -> \_ -> [])

-- Automata recognising an empty word only
epsA :: Auto a ()
epsA = A [()] [()] (\_ -> True) (\_ -> \_ -> [])

-- maps elements of first argument to Left, second to Right and joins lists
mapLR :: [a] -> [b] -> [Either a b]
mapLR xs ys = [Left x | x <- xs] ++ [Right y | y <- ys]

-- changes the list into a list of Left elements
mapL :: [a] -> [Either a b]
mapL xs = mapLR xs []

-- changes the list into a list of Right elements
mapR :: [b] -> [Either a b]
mapR xs = mapLR [] xs

{-
    Creates a copy of the automata.
    Simply maps all states to Left and creates accept and transition functions.
-}
leftA :: Auto a q -> Auto a (Either q r)
leftA aut = A newStates newInit newAccept newTrans where
    newStates = (mapL (states aut))
    newInit = (mapL (initStates aut))
    newAccept = either (isAccepting aut) (\_ -> False)
    newTrans (Left s) w = mapL (transition aut s w)

{-
    Creates the automata that accepts the sum of two languages.
    Simply maps all states of the first automata to Left, the second automata
    to Right and creates accept and transition functions.
-}
sumA :: Auto a q1 -> Auto a q2 -> Auto a (Either q1 q2)
sumA aut1 aut2 = A newStates newInit newAccept newTrans where
    newStates = mapLR (states aut1) (states aut2)
    newInit = mapLR (initStates aut1) (initStates aut2)
    newAccept = either (isAccepting aut1) (isAccepting aut2)
    newTrans (Left s) w = mapL (transition aut1 s w)
    newTrans (Right s) w = mapR (transition aut2 s w)

{-
    Creates the automata that accepts the concatenation of two languages.
    New initial states are composed of all initial states of the left automata
    plus, in case any of those states is an accepting state, the initial
    states of the right automata. The accepting states are the accepting states
    of the right automata.
-}
thenA :: Auto a q1 -> Auto a q2 -> Auto a (Either q1 q2)
thenA (A sts1 init1 acc1 tr1) (A sts2 init2 acc2 tr2) = let
    newStates = mapLR sts1 sts2
    newInit | any acc1 init1 = mapLR init1 init2
            | otherwise = mapL init1
    newAccept = either (\_ -> False) acc2
    newTrans (Left s) w | any acc1 (tr1 s w) = mapLR (tr1 s w) init2
                        | otherwise = mapL (tr1 s w)
    newTrans (Right s) w = mapR (tr2 s w) in
        A newStates newInit newAccept newTrans

{-
    function that when given the list of transitions returns the filtered list,
    which does not include empty transitions (with no reachable state).
    Also removes duplicates in the lists of reachable states.
-}
filterEmptyTransitions :: (Eq q, Eq a) => [(q,a,[q])] -> [(q,a,[q])]
filterEmptyTransitions trns = let
    isEmpty [] = True
    isEmpty xs = False in
        [(t, c, nub ts) | (t, c, ts) <- trns, not (isEmpty ts)]

{-
    Creates an automata based on the lists of: all states, initial
    states, accepting states and transitions.
    Removes possible duplicates from the lists of states and filters
    transitions.
-}
fromLists :: (Eq q, Eq a) => [q] -> [q] -> [q] -> [(q,a,[q])] -> Auto a q
fromLists sts iSts accSts trns = A (nub sts) (nub iSts) newAcc newTrans where
    accSts' = nub accSts
    newAcc s = s `elem` accSts'
    filteredTrans = filterEmptyTransitions (trns)
    newTrans s w = findTrans s w filteredTrans where
        findTrans s w [] = []
        findTrans s w ((s', w', sts'):ts) | s == s' && w == w' = sts'
                                          | otherwise = findTrans s w ts
{-
    Creates the tuple of lists describing the automata.
    The lists are in the same format as in 'fromLists' function.
    Doesn't include empty transitions.
-}
toLists :: (Enum a, Bounded a) => Auto a q -> ([q],[q],[q],[(q,a,[q])])
toLists aut = (sts, initSts, accSts, trns) where
    sts = states aut
    initSts = initStates aut
    accSts = [s | s <- sts, isAccepting aut s]
    trns = foldr (++) [] (map makeTransition sts) where
        makeTransition s = transList where
            transList = [t | t <- map singleTrans [minBound .. maxBound],
                             not (empty t)]
            singleTrans a = (s, a, transition aut s a)
            empty (_, _ , []) = True
            empty (_, _ , xs) = False

-- Automata recognising language {c}
symA :: Eq a => a -> Auto a Bool
symA c = fromLists [True, False] [False] [True] [(False, c, [True])]


instance (Show a, Enum a, Bounded a, Show q) => Show (Auto a q) where
    show aut = let (s, i, a, t) = toLists aut in
        intercalate " " [show s, show i, show a, show t]

        

