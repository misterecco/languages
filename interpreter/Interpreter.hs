module Main where

import AbsProlog
import Db
import ErrM
import ParProlog
import Solver

import Control.Monad.State
import System.IO (hPutStrLn, stderr)
import System.IO.Error (catchIOError, ioeGetErrorString)


runSentence :: Sentence -> StateWriterMonad ()
runSentence q@(Query t) = do
  db <- get
  liftIO $ print q
  liftIO $ solve db t
runSentence (SentenceClause c) = addClause c


runSentences :: [Sentence] -> StateWriterMonad ()
runSentences = mapM_ runSentence


runProgram :: Program -> IO ()
runProgram (Program1 sentences) = evalStateT (runSentences sentences) emptyDatabase


runProlog :: String -> IO ()
runProlog s = let ts = myLexer s in case pProgram ts of
   Bad s    -> fail "Parse failed..."
   Ok  tree -> runProgram tree


errorHandler :: IOError -> IO ()
errorHandler e = hPutStrLn stderr $ "ERROR: " ++ ioeGetErrorString e


processInput :: IO ()
processInput = getContents >>= runProlog


main = processInput `catchIOError` errorHandler
