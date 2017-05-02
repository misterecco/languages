module Main where

import ParProlog
import AbsProlog
import ErrM

import Control.Monad.Reader
import Control.Monad.State

import Data.Map

type FunctorSig = (Name, Int)
type Database = Map FunctorSig [Clause]

addToDb :: (Name, Int) -> [Clause] -> Database -> Database
addToDb = insertWith (++)


-- TODO: Use state transformer to catch errors (wrong head)
-- TODO: Implement all cases
addClause :: Clause -> State Database ()
addClause uc@(UnitClause (Funct name args)) = do
  state <- get
  put $ addToDb (name, length args) [uc] state
  return ()

addClause r@(Rule (Funct name args) _) = do
  state <- get
  put $ addToDb (name, length args) [r] state
  return ()

runSentence :: Sentence -> State Database ()
runSentence (Directive d) = return ()
runSentence (Query q) = return ()
runSentence (SentenceClause c) = addClause c


runSentences :: [Sentence] -> State Database ()
runSentences [] = return ()
runSentences (s:ss) = do
  runSentence s
  runSentences ss


runProgram :: Program -> String
runProgram (Program1 sentences) =
  let s = execState (runSentences sentences) empty
    in unlines $ stateToString s


stateToString :: Database -> [String]
stateToString = foldrWithKey foo []
  where
    foo (name, arity) args acc = (show name ++ ", " ++ show arity ++ ": " ++ show args) : acc


runProlog :: String -> String
runProlog s = let ts = myLexer s in case pProgram ts of
   Bad s    -> "\nParse failed...\n"
   Ok  tree -> runProgram tree


main = do
  interact runProlog
  putStrLn ""
