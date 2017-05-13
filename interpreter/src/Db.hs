module Db where

import AbsProlog

import System.IO.Error (catchIOError, ioeGetErrorString)
import Control.Monad.State

import qualified Data.Map as M

type FunctorSig = (Name, Int)
type Database = M.Map FunctorSig [Clause]
type StateWriterMonad = StateT Database IO


addToDb :: FunctorSig -> [Clause] -> Database -> Database
addToDb = M.insertWith $ flip (++)


emptyDatabase :: Database
emptyDatabase = M.empty


dataBaseToString :: Database -> [String]
dataBaseToString = M.foldrWithKey foo []
  where
    foo (name, arity) args acc = (show name ++ "/" ++ show arity ++ ": " ++ show args) : acc


addTerm :: Term -> Clause -> StateWriterMonad ()
addTerm (Funct name args) clause = modify $ addToDb (name, length args) [clause]
addTerm (Const (Atom name)) clause = modify $ addToDb (name, 0) [clause]
addTerm term _ = liftIO $ fail $ "Unexpected term as a clause head: " ++ show term


addClause :: Clause -> StateWriterMonad ()
addClause uc@(UnitClause term) = addTerm term uc
addClause r@(Rule term _) = addTerm term r
