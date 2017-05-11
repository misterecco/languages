module Main where

import Solver
import Db
import ParProlog
import AbsProlog
import ErrM

import System.IO.Error (catchIOError, ioeGetErrorString)
import Control.Monad.State


runSentence :: Sentence -> StateWriterMonad ()
runSentence (Directive d) = return ()
runSentence (Query q) = do
  db <- get
  liftIO $ solve db q
runSentence (SentenceClause c) = addClause c

runSentences :: [Sentence] -> StateWriterMonad ()
runSentences = mapM_ runSentence

runProgram :: Program -> IO ()
runProgram (Program1 sentences) = do
  db <- execStateT (runSentences sentences) emptyDatabase
  putStrLn $ unlines $ dataBaseToString db
  putStrLn "All OK, quitting..."

runProlog :: String -> IO ()
runProlog s = let ts = myLexer s in case pProgram ts of
   Bad s    -> fail "Parse failed..."
   Ok  tree -> runProgram tree


errorHandler :: IOError -> IO ()
errorHandler e = putStrLn $ "Error: " ++ ioeGetErrorString e

processInput :: IO ()
processInput = getContents >>= runProlog

main = processInput `catchIOError` errorHandler
