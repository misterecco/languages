module Auto
(
  Auto,
  accepts,
  emptyA,
  epsA,
  symA,
  leftA,
  sumA,
  thenA,
  fromLists,
  toLists,
) where

import Data.List (nub, find)


data Auto a q = A {
  states :: [q],
  initStates :: [q],
  isAccepting :: q -> Bool,
  transition :: q -> a -> [q]
}


instance (Enum a, Bounded a, Show a, Show q) => Show (Auto a q) where
  show aut = show $ toLists aut


accepts :: Eq q => Auto a q -> [a] -> Bool
accepts (A _ initSt isAcc trans) word = foo word uniqInitSt
  where
    uniqInitSt = nub initSt
    foo _ [] = False
    foo [] sts = any isAcc sts
    foo (c:cs) sts = foo cs (nub $ concatMap (`trans` c) sts)


emptyA :: Auto a ()
emptyA = A {
  states = [],
  initStates = [],
  isAccepting = const False,
  transition = \_ _ -> []
}


epsA :: Auto a ()
epsA = A {
  states = [()],
  initStates = [()],
  isAccepting = (== ()),
  transition = \_ _ -> []
}


symA :: Eq a => a -> Auto a Bool
symA c = A {
  states = [False, True],
  initStates = [False],
  isAccepting = (== True),
  transition = \st ch -> case (st, ch) of
    (False, l) -> [True | l == c]
    (_, _) -> []
}


leftA :: Auto a q -> Auto a (Either q r)
leftA (A st initSt isAcc trans) = A {
  states = map Left st,
  initStates = map Left initSt,
  isAccepting = either isAcc (const False),
  transition = \state ch -> case (state, ch) of
    (Left s, c) -> map Left $ trans s c
    (_, _) -> []
}


sumA :: Auto a q1 -> Auto a q2 -> Auto a (Either q1 q2)
sumA (A stL initStL isAccL transL) (A stR initStR isAccR transR) = A {
  states = map Left stL ++ map Right stR,
  initStates = map Left initStL ++ map Right initStR,
  isAccepting = either isAccL isAccR,
  transition = \st ch -> case (st, ch) of
    (Left s, c) -> map Left $ transL s c
    (Right s, c) -> map Right $ transR s c
}


thenA :: Auto a q1 -> Auto a q2 -> Auto a (Either q1 q2)
thenA (A stL initStL isAccL transL) (A stR initStR isAccR transR) = A {
  states = map Left stL ++ map Right stR,
  initStates = map Left initStL ++ if any isAccL initStL
                                     then map Right initStR
                                     else [],
  isAccepting = either (const False) isAccR,
  transition = \st ch -> case (st, ch) of
    (Left s, c) -> map Left transLSt ++ if any isAccL transLSt
                                          then map Right initStR
                                          else []
      where transLSt = transL s c
    (Right s, c) -> map Right $ transR s c
}


fromLists :: (Eq q, Eq a) => [q] -> [q] -> [q] -> [(q,a,[q])] -> Auto a q
fromLists st initSt accSt trans = A {
  states = st,
  initStates = initSt,
  isAccepting = (`elem` accSt),
  -- TODO: use Maybe monad
  transition = \dst ch -> let f = find (\(s, c, _) -> s == dst && c == ch) trans in
    case f of
      Just (_, _, d) -> d
      Nothing -> []
}


toLists :: (Enum a, Bounded a) => Auto a q -> ([q],[q],[q],[(q,a,[q])])
toLists (A st initSt isAcc trans) = (
    st,
    initSt,
    filter isAcc st,
    [(src, ch, dst) | src <- st, ch <- [minBound..maxBound], let dst = trans src ch, not $ null dst]
  )
