{-# LANGUAGE OverloadedStrings #-}

module E where

data Exp
  = EInt Integer
  | EAdd Exp Exp
  | ESub Exp Exp
  | EMul Exp Exp
  | EVar String
  | ELet String Exp Exp

instance Show Exp where
  show (EInt x) = show x
  show (EAdd x y) = show x ++ " + " ++ show y
  show (ESub x y) = show x ++ " - " ++ show y
  show (EMul x y) = show x ++ " * " ++ show y
  show (EVar x) = x
  show (ELet x e1 e2) = "let " ++ x ++ " = " ++ show e1 ++ " in " ++ show e2

instance Eq Exp where
  (EInt x) == (EInt y) = x == y
  (EAdd x1 y1) == (EAdd x2 y2) = x1 == x2 && y1 == y2
  (ESub x1 y1) == (ESub x2 y2) = x1 == x2 && y1 == y2
  (EMul x1 y1) == (EMul x2 y2) = x1 == x2 && y1 == y2
  (EVar x) == (EVar y) = x == y
  (ELet x1 e11 e21) == (ELet x2 e12 e22) = x1 == x2 && e11 == e12 && e21 == e22
  _ == _ = False


instance Num Exp where
  fromInteger = EInt
  x + y = EAdd x y
  x * y = EMul x y
  x - y = ESub x y
  signum = undefined
  abs = undefined

testExp2 :: Exp
testExp2 = (2 + 2) * 3

simpl :: Exp -> Exp
simpl (EAdd x (EInt 0)) = x
simpl (EAdd (EInt 0) x) = x
simpl (EMul x (EInt 1)) = x
simpl (EMul (EInt 1) x) = x
simpl x = x
