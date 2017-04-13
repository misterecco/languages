{-# LANGUAGE OverloadedStrings #-}

module Zad_04 where

import Data.String

data Exp
  = EInt Int             -- stała całkowita
  | EAdd Exp Exp         -- e1 + e2
  | ESub Exp Exp         -- e1 - e2
  | EMul Exp Exp         -- e1 * e2
  | EVar String          -- zmienna
  | ELet String Exp Exp  -- let var = e1 in e2
    deriving (Eq)

instance Show Exp where
  show (EInt i) = show i
  show (Eadd e1 e2) = (show e1) ++ "+" ++ (show e2)
  show (Esub e1 e2) = (show e1) ++ "-" ++ (show e2)
  show (Emul e1 e2) = (show e1) ++ "*" ++ (show e2)
  show (EVar s) = s
  show (ELet Val e1 e2) = "let ..."

instance IsString Exp where
  fromString = EVar

instance Num Exp where...
