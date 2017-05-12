module Solver where

import Db
import AbsProlog
import Unifier

import Debug.Trace

import Control.Monad.Except
import Data.List (nub)
import Data.List.Split (splitOn)
import Data.Maybe (catMaybes, fromMaybe)

import qualified Data.Map as M


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


filterVars :: [Term] -> [Variable]
filterVars = foldr filterVar []


renameVar :: Int -> Term -> Term
renameVar n (Var (Variable var)) = Var $ Variable $ name ++ "@" ++ show n
  where (name:_) = splitOn "@" var
renameVar _ term = term


renameVars :: Int -> Term -> Term
renameVars n = foldTerm (renameVar n)


renameClause :: Int -> Clause -> Clause
renameClause n (Rule t gs) = Rule (renameVars n t) (map (renameVars n) gs)
renameClause n (UnitClause t) = UnitClause $ renameVars n t


clausesFor :: FunctorSig -> Database -> ExceptMonad [Clause]
clausesFor fsig@(name, arity) db =
  case M.lookup fsig db of
    Just clauses -> return clauses
    Nothing -> fail $ "Undefined procedure: " ++ show name ++ "/" ++ show arity


renameClauses :: Int -> Database -> Term -> ExceptMonad [Clause]
renameClauses n db (Const (Atom name)) = do
  clauses <- clausesFor (name, 0) db
  return $ map (renameClause n) clauses
renameClauses n db (Funct name args) = do
  clauses <- clausesFor (name, length args) db
  return $ map (renameClause n) clauses
renameClauses _ _ _ = return []


toTermPair :: Clause -> (Term, [Term])
toTermPair (Rule h g) = (h, g)
toTermPair (UnitClause h) = (h, [])


toTermPairs :: [Clause] -> [(Term, [Term])]
toTermPairs = map toTermPair


prooftree :: Database -> Int -> Subst -> [Term] -> ExceptMonad Prooftree
prooftree db = pt where
  pt :: Int -> Subst -> [Term] -> ExceptMonad Prooftree
  pt _ s [] = return $ Done s
  pt n s (g:gs) = do
    renamedClauses <- renameClauses n db g
    result <- sequence [ pt (n+1) (u@@s) (mapApply u (tp++gs)) |
                       (tm, tp) <- toTermPairs (traceShowId renamedClauses),
                       -- TODO: catch errors instead of converting to empty list
                       u <- either (const []) id (fromMaybe (Right []) (runExceptT $ unify g tm)) ]
    return $ Choice result


search :: Prooftree -> ExceptMonad [Subst]
search (Done s) = return [s]
search (Choice pts) = do
  let spt = map search pts
  sst <- sequence spt
  return $ concat sst


prove :: Database -> [Term] -> ExceptMonad [Subst]
prove db t = do
  pt <- prooftree db 1 nullSubst (traceShowId t)
  search pt


runProve :: Database -> Term -> IO [Subst]
runProve db func = do
  let subs = runExcept $ prove db [func]
  case subs of
    Left err -> fail err
    Right v -> return v


solve :: Database -> Term -> IO ()
solve db (Const (Atom a)) = do
  -- TOOD: do not fail silently
  let g = clausesFor (a, 0) db
  -- TODO: it doesn't have to be unit clause
  putStrLn "true"
solve db func@(Funct name terms) = do
  let vars = filterVars terms
  subs <- runProve db func
  let results = if null subs then [["false"]]
                             else map (printSubs vars) subs
  let printable = map unwords results
  putStrLn $ unlines printable
solve db t = fail $ "Wrong type of term in query: " ++ show t
