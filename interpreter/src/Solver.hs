module Solver where

import Db
import AbsProlog

import Debug.Trace


import Control.Monad.Except
import Data.List.Split (splitOn)
import Data.Maybe (catMaybes, fromMaybe)

import qualified Data.Map as M

type ExceptIOMonad = ExceptT String IO
type Subst = Variable -> Term
data Prooftree = Done Subst | Choice [Prooftree]


foldTerm :: (Term -> Term) -> Term -> Term
foldTerm f v@(Var _) = f v
foldTerm f c@(Const _) = c
foldTerm f (Funct name terms) = Funct name $ map (foldTerm f) terms
foldTerm f (List l) = List $ foldList l
  where foldList ListEmpty = ListEmpty
        foldList (ListChar s) = ListChar s
        foldList (ListNonEmpty le) = ListNonEmpty $ foldLE le
        foldLE (LESingle t) = LESingle $ foldTerm f t
        foldLE (LESeq t le) = LESeq (foldTerm f t) (foldLE le)
        foldLE (LEHead h t) = LEHead (foldTerm f h) (foldTerm f t)
foldTerm f (OpNegate t) = OpNegate $ foldTerm f t
foldTerm f (OpArNeg t) = OpArNeg $ foldTerm f t
foldTerm f (OpSequence t1 t2) = OpSequence (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpUnifies t1 t2) = OpUnifies (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpNotUnifies t1 t2) = OpNotUnifies (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpEqual t1 t2) = OpEqual (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpNotEqual t1 t2) = OpNotEqual (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArIs t1 t2) = OpArIs (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArEqual t1 t2) = OpArEqual (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArNotEqual t1 t2) = OpArNotEqual (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArLt t1 t2) = OpArLt (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArGt t1 t2) = OpArGt (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArLte t1 t2) = OpArLte (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArGte t1 t2) = OpArGte (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArAdd t1 t2) = OpArAdd (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArSub t1 t2) = OpArSub (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArMul t1 t2) = OpArMul (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArDiv t1 t2) = OpArDiv (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArMod t1 t2) = OpArMod (foldTerm f t1) (foldTerm f t2)


renameVar :: Int -> Term -> Term
renameVar n (Var (Variable var)) = Var $ Variable $ name ++ "@" ++ show n
  where (name:_) = splitOn "@" var
renameVar _ term = term


renameVars :: Int -> Term -> Term
renameVars n = foldTerm (renameVar n)


renameClause :: Int -> Clause -> Clause
renameClause n (Rule t1 t2) = Rule (renameVars n t1) (renameVars n t2)
renameClause n (UnitClause t) = UnitClause $ renameVars n t


clausesFor :: FunctorSig -> Database -> IO [Clause]
clausesFor fsig@(name, arity) db =
  case M.lookup fsig db of
    Just clauses -> return clauses
    Nothing -> fail $ "Undefined procedure: " ++ show name ++ "/" ++ show arity


renameClauses :: Int -> Database -> Term -> IO [Clause]
renameClauses n db (Const (Atom name)) = do
  clauses <- clausesFor (name, 0) db
  return $ map (renameClause n) clauses
renameClauses n db (Funct name args) = do
  clauses <- clausesFor (name, length args) db
  return $ map (renameClause n) clauses


(->>) :: Variable -> Term -> Subst
(->>) var t v | v == var = t
              | otherwise = Var v


(@@) :: Subst -> Subst -> Subst
s1 @@ s2 = apply s1 . s2

nullSubst :: Subst
nullSubst = Var


applyToVar :: Subst -> Term -> Term
applyToVar s (Var v@(Variable _)) = s v
applyToVar s t = t


apply :: Subst -> Term -> Term
apply s = foldTerm (applyToVar s)


mapApply :: Subst -> [Term] -> [Term]
mapApply = map . apply


baseSubst :: [Subst]
baseSubst = [nullSubst]

-- TODO: signal errors
unify :: Term -> Term -> Maybe [Subst]
unify (Var x) (Var y) = if x == y then return baseSubst else return [x ->> Var y]
unify (Var x) t = return [x ->> t]
unify t v@(Var x) = unify v t
unify (Funct name1 terms1) (Funct name2 terms2) =
  if name1 == name2 then listUnify terms1 terms2 else Nothing
unify (List l1) (List l2) = unifyLists l1 l2
unify (Const x) (Const y) = if x == y then return baseSubst else Nothing
unify _ _ = Nothing
-- TODO: unify other types of terms

unifyLists :: Lst -> Lst -> Maybe [Subst]
unifyLists ListEmpty ListEmpty = return baseSubst
unifyLists (ListChar s1) (ListChar s2) =
  if s1 == s2 then return baseSubst else Nothing
unifyLists (ListChar s) ListEmpty = if null s then return baseSubst else Nothing
unifyLists ListEmpty (ListChar s) = unifyLists (ListChar s) ListEmpty
unifyLists (ListChar s) le@(ListNonEmpty _) = if null s then Nothing
  else unifyLists (ListNonEmpty $ LEHead (List $ ListChar [head s]) (List $ ListChar $ tail s)) le
unifyLists le@(ListNonEmpty _) lc@(ListChar _) = unifyLists lc le
unifyLists (ListNonEmpty le1) (ListNonEmpty le2) = unifyLE le1 le2 where
  unifyLE (LESingle t1) (LESingle t2) = unify t1 t2
  unifyLE (LESeq t1 le1) (LESeq t2 le2) =
    listUnify [t1, List $ ListNonEmpty le1] [t2, List $ ListNonEmpty le2]
  unifyLE (LEHead h1 t1) (LEHead h2 t2) = listUnify [t1, h1] [t2, h2]
  unifyLE (LESingle t1) (LEHead h t) = listUnify [t1, List ListEmpty] [h, t]
  unifyLE le1@(LEHead _ _) le2@(LESingle _) = unifyLE le2 le1
  unifyLE (LESeq t1 t2) (LEHead h t) = listUnify [t1, List $ ListNonEmpty t2] [h, t]
  unifyLE leh@(LEHead _ _) les@(LESeq _ _) = unifyLE les leh
  unifyLE _ _ = Nothing
unifyLists _ _ = Nothing


listUnify :: [Term] -> [Term] -> Maybe [Subst]
listUnify [] [] = return [nullSubst]
listUnify (t:ts) (r:rs) = do
  u <- unify t r
  return [u2 @@ u1 | u1 <- u,
                     let uu = concat $ listUnify (mapApply u1 ts) (mapApply u1 rs),
                     u2 <- uu]
listUnify _ _ = Nothing


toTermPair :: Clause -> (Term, [Term])
toTermPair (Rule h g) = (h, [g])
toTermPair (UnitClause h) = (h, [])

toTermPairs :: [Clause] -> [(Term, [Term])]
toTermPairs = map toTermPair


prooftree :: Database -> Int -> Subst -> [Term] -> IO Prooftree
prooftree db = pt where
  pt :: Int -> Subst -> [Term] -> IO Prooftree
  pt _ s [] = return $ Done s
  pt n s (g:gs) = do
    renamedClauses <- renameClauses n db g
    result <- sequence [ pt (n+1) (u@@s) (mapApply u (tp++gs)) |
                       (tm, tp) <- toTermPairs (traceShowId renamedClauses),
                       u <- fromMaybe [] (unify g tm) ]
    return $ Choice result


search :: Prooftree -> IO [Subst]
search (Done s) = return [s]
search (Choice pts) = do
  let spt = map search pts
  sst <- sequence spt
  return $ concat sst



prove :: Database -> [Term] -> IO [Subst]
prove db t = do
  pt <- prooftree db 1 nullSubst (traceShowId t)
  search pt


printSubs :: [Variable] -> Subst -> [String]
printSubs ts s = if null subs then ["true"] else subs where
  subs = [show t ++ " = " ++ show sub | t <- ts, let sub = s t, sub /= Var t]


filterVar :: Term -> [Variable] -> [Variable]
filterVar (Var v) acc = v : acc
filterVar (Funct _ terms) acc = filterVars terms ++ acc
filterVar (List l) acc = foo l acc
  where
    foo (ListNonEmpty le) acc = foo2 le acc
    foo _ acc = acc
    foo2 (LESingle t) acc = filterVar t acc
    foo2 (LESeq t le) acc = filterVar t (foo2 le acc)
    foo2 (LEHead h t) acc = filterVar h (filterVar t acc)
filterVar _ acc = acc
-- TODO: should anything else be here?

filterVars :: [Term] -> [Variable]
filterVars = foldr filterVar []


-- TODO: rename variables in database in step 0
solve :: Database -> Term -> IO ()
solve _ (Const c) = print $ show c
solve db func@(Funct name terms) = do
  -- putStrLn $ unlines $ dataBaseToString db
  let vars = filterVars terms
  -- print vars
  subs <- prove db [func]
  let results = if null subs then [["false"]]
                             else map (printSubs vars) subs
  let printable = map unwords results
  putStrLn $ unlines printable
solve db t = fail $ "Wrong type of term in query: " ++ show t
