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

import System.IO.Error (catchIOError, ioeGetErrorString)


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
filterVars t = nub $ foldr filterVar [] t


renameVar :: Int -> Term -> Term
renameVar n (Var (Variable var)) = Var $ Variable $ name ++ "@" ++ show n
  where (name:_) = splitOn "@" var
renameVar _ term = term


renameVars :: Int -> Term -> Term
renameVars n = foldTerm (renameVar n)


renameClause :: Int -> Clause -> Clause
renameClause n (Rule t gs) = Rule (renameVars n t) (map (renameVars n) gs)
renameClause n (UnitClause t) = UnitClause $ renameVars n t


clausesFor :: FunctorSig -> Database -> ExceptMaybeMonad [Clause]
clausesFor fsig@(name, arity) db =
  case M.lookup fsig db of
    Just clauses -> return clauses
    Nothing -> fail $ "Undefined procedure: " ++ show name ++ "/" ++ show arity


renameClauses :: Int -> Database -> Term -> ExceptMaybeMonad [Clause]
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


-- TODO: better name?
substantiate :: Database -> Subst -> Term -> ExceptMaybeMonad ([Subst], Term)
-- substantiate s t@(OpUnifies t1 t2) = do
--   s1 <- unify t1 t2
--   return (s1, t)
substantiate db s t@(OpEqual t1 t2) = if t1 == t2 then return ([], t) else failure
substantiate db s t@(OpNotEqual t1 t2) = if t1 /= t2 then return ([], t) else failure
substantiate db s t = return ([], t)


prooftree :: Database -> Int -> Subst -> [Term] -> ExceptMaybeMonad Prooftree
prooftree db = pt where
  pt :: Int -> Subst -> [Term] -> ExceptMaybeMonad Prooftree
  pt _ s [] = return $ Done s
  pt n ns (ng:gs) = do
    -- (nss, ng) <- substantiate db s g
    -- let ns = foldr (@@) s nss
    renamedClauses <- renameClauses n db ng
    let tmTpList = toTermPairs $ traceShowId renamedClauses
    uuu <- mapM (unifyHeader ng) tmTpList
    let uu = concat uuu
    result <- sequence [ pt (n+1) (u@@ns) (mapApply u (tp++gs)) |
                       (tm, tp, u) <- uu ]
    return $ Choice result
    where
      unifyHeader g (tm, tp) = do
         us <- unify g tm
         return [(tm, tp, u) | u <- us]


search :: Prooftree -> ExceptMaybeMonad [Subst]
search (Done s) = return [s]
search (Choice pts) = do
  let spt = map search pts
  sst <- sequence spt
  return $ concat sst


prove :: Database -> [Term] -> ExceptMaybeMonad [Subst]
prove db t = do
  pt <- prooftree db 1 nullSubst (traceShowId t)
  search pt


solve :: Database -> Term -> IO ()
solve db c@(Const (Atom a)) = do
  let subs = runExceptT $ prove db [c]
  case subs of
    Nothing -> putStrLn "false"
    Just s -> case s of
      Left err -> fail err
      Right substitutions -> putStrLn "true"
solve db func@(Funct name terms) = do
  let vars = filterVars terms
  let subs = runExceptT $ prove db [func]
  case subs of
    Nothing -> putStrLn "false"
    Just s -> case s of
      Left err -> fail err
      Right substitutions -> do
        let results = map (printSubs vars) substitutions
        let printable = map unwords results
        putStrLn $ unlines printable
solve db t = fail $ "Wrong type of term in query: " ++ show t
