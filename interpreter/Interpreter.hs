module Main where

import ParProlog
import AbsProlog
import ErrM

import System.IO.Error (catchIOError, ioeGetErrorString)
import Control.Monad.State

import Data.Map

type FunctorSig = (Name, Int)
type Database = Map FunctorSig [Clause]
type StateWriterMonad = StateT Database IO


addToDb :: FunctorSig -> [Clause] -> Database -> Database
addToDb = insertWith (++)

-- getFromDb :: FunctorSig -> Database -> [Clause]
-- getFromDb fs db =

dataBaseToString :: Database -> [String]
dataBaseToString = foldrWithKey foo []
  where
    foo (name, arity) args acc = (show name ++ ", " ++ show arity ++ ": " ++ show args) : acc


addTerm :: Term -> Clause -> StateWriterMonad ()
addTerm (Funct name args) clause = modify $ addToDb (name, length args) [clause]
addTerm (Const (Atom name)) clause = modify $ addToDb (name, 0) []
addTerm term _ = liftIO $ fail $ "Unexpected term: " ++ show term

addClause :: Clause -> StateWriterMonad ()
addClause uc@(UnitClause term) = addTerm term uc
addClause r@(Rule term _) = addTerm term r


runSentence :: Sentence -> StateWriterMonad ()
runSentence (Directive d) = return ()
runSentence (Query q) = return ()
runSentence (SentenceClause c) = addClause c


runSentences :: [Sentence] -> StateWriterMonad ()
runSentences [] = return ()
runSentences (s:ss) = do
  -- liftIO $ putStrLn "Wrong head (two terms on the left side)"
  runSentence s
  runSentences ss


runProgram :: Program -> IO ()
runProgram (Program1 sentences) = do
  db <- execStateT (runSentences sentences) empty
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
