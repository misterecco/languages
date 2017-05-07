module Solver where

import ParProlog
import AbsProlog
import ErrM

import System.IO.Error (catchIOError, ioeGetErrorString)
import Control.Monad.State
import Data.List.Split (splitOn)

import qualified Data.Map as M
