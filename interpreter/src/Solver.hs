module Solver where

import Db
import AbsProlog
import Unifier
import Extensions

import Debug.Trace

import Control.Monad.Except
import Data.List (nub)
import Data.List.Split (splitOn)
import Data.Maybe (catMaybes, fromMaybe)

import qualified Data.Map as M

import System.IO.Error (catchIOError, ioeGetErrorString)


printSubs :: [Variable] -> Subst -> [String]
printSubs ts s = if null subs then ["true"] else subs where
  subs = [show t ++ " = " ++ show sub | t <- ts, let sub = s t, sub /= Var t ]


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


clausesFor :: FunctorSig -> Database -> ExceptMonad [Clause]
clausesFor fsig@(name, arity) db =
  case M.lookup fsig db of
    Just clauses -> return clauses
    Nothing -> throwError $ "Undefined procedure: " ++ show name ++ "/" ++ show arity


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


ptTerm :: Database -> Int -> Subst -> Term -> [Term] -> ExceptMonad Prooftree
ptTerm db n s g gs = do
  renamedClauses <- renameClauses n db g
  result <- sequence [ pt db (n+1) (u@@s) (mapApply u (tp++gs)) |
                     (tm, tp) <- toTermPairs (traceShowId renamedClauses),
                     u <- unify g tm ]
  return $ Choice result


-- extensions to prolog (non-declarative constructs)
ptExt :: Database -> Int -> Subst -> Term -> [Term] -> ExceptMonad Prooftree
ptExt db n s g gs =
  case runExceptT $ check db g of
    Nothing -> return $ Choice []
    Just x -> case x of
      Left err -> throwError err
      Right subs -> do
        let ns = foldr (@@) s subs
        result <- pt db (n+1) ns (mapApply ns gs)
        return $ Choice [result]


pt :: Database -> Int -> Subst -> [Term] -> ExceptMonad Prooftree
pt _ _ s [] = return $ Done s
pt db n s (g:gs) = case g of
  (Funct _ _) -> ptTerm db n s g gs
  (Var _) -> ptTerm db n s g gs
  (Const _) -> ptTerm db n s g gs
  (List _) -> ptTerm db n s g gs
  _ -> ptExt db n s g gs


search :: Prooftree -> ExceptMonad [Subst]
search (Done s) = return [s]
search (Choice pts) = do
  let spt = map search pts
  sst <- sequence spt
  return $ concat sst


prove :: Database -> [Term] -> ExceptMonad [Subst]
prove db t = do
  prooftree <- pt db 1 nullSubst (traceShowId t)
  search prooftree


solve :: Database -> Term -> IO ()
solve db c@(Const (Atom a)) = case runExcept $ prove db [c] of
  Left err -> fail err
  Right subs -> if null subs then putStrLn "false" else putStrLn "true"
solve db func@(Funct name terms) = do
  let vars = filterVars terms
  case runExcept $ prove db [func] of
    Left err -> fail err
    Right subs -> do
      let results = map (printSubs vars) subs
      let printable = map unwords results
      putStrLn $ unlines printable
solve db t = fail $ "Wrong type of term in query: " ++ show t
