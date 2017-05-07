module Main where

import ParProlog
import AbsProlog
import ErrM

-- import Solver

import System.IO.Error (catchIOError, ioeGetErrorString)
import Control.Monad.State
import Data.List.Split (splitOn)

import qualified Data.Map as M

type FunctorSig = (Name, Int)
type Database = M.Map FunctorSig [Clause]
type StateWriterMonad = StateT Database IO


addToDb :: FunctorSig -> [Clause] -> Database -> Database
addToDb = M.insertWith (++)


emptyDatabase :: Database
emptyDatabase = M.empty

-- getFromDb :: FunctorSig -> Database -> [Clause]
-- getFromDb fs db =

dataBaseToString :: Database -> [String]
dataBaseToString = M.foldrWithKey foo []
  where
    foo (name, arity) args acc = (show name ++ "/" ++ show arity ++ ": " ++ show args) : acc


addTerm :: Term -> Clause -> StateWriterMonad ()
addTerm (Funct name args) clause = modify $ addToDb (name, length args) [clause]
addTerm (Const (Atom name)) clause = modify $ addToDb (name, 0) [UnitClause $ Const $ Atom $ Name "true"]
addTerm term _ = liftIO $ fail $ "Unexpected term: " ++ show term


addClause :: Clause -> StateWriterMonad ()
addClause uc@(UnitClause term) = addTerm term uc
addClause r@(Rule term _) = addTerm term r


runSentence :: Sentence -> StateWriterMonad ()
runSentence (Directive d) = return ()
runSentence (Query q) = do
  db <- get
  liftIO $ solve db q
runSentence (SentenceClause c) = addClause c


runSentences :: [Sentence] -> StateWriterMonad ()
runSentences [] = return ()
runSentences (s:ss) = do
  -- liftIO $ putStrLn "Wrong head (two terms on the left side)"
  runSentence s
  runSentences ss


runProgram :: Program -> IO ()
runProgram (Program1 sentences) = do
  db <- execStateT (runSentences sentences) emptyDatabase
  putStrLn $ unlines $ dataBaseToString db
  putStrLn "All OK, quitting..."


runProlog :: String -> IO ()
runProlog s = let ts = myLexer s in case pProgram ts of
   Bad s    -> fail "parse failed..."
   Ok  tree -> runProgram tree




errorHandler :: IOError -> IO ()
errorHandler e = putStrLn $ "Error: " ++ ioeGetErrorString e

processInput :: IO ()
processInput = getContents >>= runProlog

main = processInput `catchIOError` errorHandler






foldTerm :: (Term -> Term) -> Term -> Term
foldTerm f v@(Var _) = f v
foldTerm f c@(Const _) = c
foldTerm f (Funct name terms) = Funct name $ map f terms
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
    Nothing -> fail $ "Existence error: " ++ show name ++ "/" ++ show arity


renameClauses :: Int -> Database -> Term -> IO [Clause]
renameClauses n db (Const (Atom name)) = do
  clauses <- clausesFor (name, 0) db
  return $ map (renameClause n) clauses
renameClauses n db (Funct name args) = do
  clauses <- clausesFor (name, length args) db
  return $ map (renameClause n) clauses


type Subst = Variable -> Term
data Prooftree = Done Subst | Choice [Prooftree]


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


unify :: Term -> Term -> [Subst]
unify (Var x) (Var y) = if x == y then [nullSubst] else [x ->> Var y]
unify (Var x) t = [x ->> t]
unify t v@(Var x) = unify v t
unify (Funct name1 terms1) (Funct name2 terms2) =
  if name1 == name2 then listUnify terms1 terms2 else []
unify _ _ = [nullSubst]
-- TODO: unify other types of terms

listUnify :: [Term] -> [Term] -> [Subst]
listUnify [] [] = [nullSubst]
listUnify (t:ts) (r:rs) = [u2 @@ u1
                          | u1 <- unify t r
                          , u2 <- listUnify (mapApply u1 ts) (mapApply u1 rs) ]
listUnify _ _ = []


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
                       (tm, tp) <- toTermPairs renamedClauses,
                       u <- unify g tm ]
    return $ Choice result


search :: Prooftree -> IO [Subst]
search (Done s) = return [s]
search (Choice pts) = do
  let spt = map search pts
  sst <- sequence spt
  return $ concat sst



prove :: Database -> [Term] -> IO [Subst]
prove db t = do
  pt <- prooftree db 1 nullSubst t
  search pt


printSubs :: [Variable] -> Subst -> [String]
printSubs ts s = [show t ++ " = " ++ show sub | t <- ts, let sub = s t]


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


solve :: Database -> Term -> IO ()
solve _ (Const c) = print $ show c
solve db func@(Funct name terms) = do
  let vars = filterVars terms
  subs <- prove db [func]
  let results = map (printSubs vars) subs
  let printable = map unwords results
  putStrLn $ unlines printable
solve db t = fail $ "Wrong type of term in query: " ++ show t
