module AbsProlog where

import Data.List

newtype Name = Name String deriving (Eq, Ord, Read)

instance Show Name where
  show (Name n) = n


newtype Variable = Variable String deriving (Eq, Ord, Read)

instance Show Variable where
  show (Variable v) = v


data Program = Program1 [Sentence] deriving (Eq, Ord, Read)

instance Show Program where
  show (Program1 sentences) = unlines $ map show sentences


data Sentence = SentenceClause Clause | Directive Term | Query Term
  deriving (Eq, Ord, Read)

instance Show Sentence where
  show (Query t) = "?- " ++ show t ++ "."
  show (Directive t) = ":- " ++ show t ++ "."
  show (SentenceClause c) = show c ++ "."


data Clause = Rule Term Term | UnitClause Term
  deriving (Eq, Ord, Read)

instance Show Clause where
  show (Rule h g) = show h ++ " :- " ++ show g
  show (UnitClause t) = show t

data Term
    = OpSequence Term Term
    | OpNegate Term
    | OpUnifies Term Term
    | OpNotUnifies Term Term
    | OpEqual Term Term
    | OpNotEqual Term Term
    | OpArIs Term Term
    | OpArEqual Term Term
    | OpArNotEqual Term Term
    | OpArLt Term Term
    | OpArGt Term Term
    | OpArLte Term Term
    | OpArGte Term Term
    | OpArAdd Term Term
    | OpArSub Term Term
    | OpArMul Term Term
    | OpArDiv Term Term
    | OpArMod Term Term
    | OpArNeg Term
    | Funct Name [Term]
    | Var Variable
    | Const Constant
    | List Lst
  deriving (Eq, Ord, Read)

instance Show Term where
  show (OpSequence t1 t2)   = show t1 ++ ", " ++ show t2
  show (OpNegate t1)        = "\\+ " ++ show t1
  show (OpUnifies t1 t2)    = show t1 ++ " = " ++ show t2
  show (OpNotUnifies t1 t2) = show t1 ++ " \\= " ++ show t2
  show (OpEqual t1 t2)      = show t1 ++ " == " ++ show t2
  show (OpNotEqual t1 t2)   = show t1 ++ " \\== " ++ show t2
  show (OpArIs t1 t2)       = show t1 ++ " is " ++ show t2
  show (OpArEqual t1 t2)    = show t1 ++ " =:= " ++ show t2
  show (OpArNotEqual t1 t2) = show t1 ++ " =\\= " ++ show t2
  show (OpArLt t1 t2)       = show t1 ++ " < " ++ show t2
  show (OpArGt t1 t2)       = show t1 ++ " > " ++ show t2
  show (OpArLte t1 t2)      = show t1 ++ " =< " ++ show t2
  show (OpArGte t1 t2)      = show t1 ++ " >= " ++ show t2
  show (OpArAdd t1 t2)      = show t1 ++ " + " ++ show t2
  show (OpArSub t1 t2)      = show t1 ++ " - " ++ show t2
  show (OpArMul t1 t2)      = show t1 ++ " * " ++ show t2
  show (OpArDiv t1 t2)      = show t1 ++ " / " ++ show t2
  show (OpArMod t1 t2)      = show t1 ++ " mod " ++ show t2
  show (OpArNeg t1)         = "-" ++ show t1
  show (Funct name terms)   = show name ++ "(" ++ intercalate ", " (map show terms) ++ ")"
  show (Var v)              = show v
  show (Const c)            = show c
  show (List l)             = show l


data Lst = ListEmpty | ListNonEmpty ListExpr | ListChar String
  deriving (Eq, Ord, Read)

instance Show Lst where
  show ListEmpty = "[]"
  show (ListChar s) = "\"" ++ s ++ "\""
  show (ListNonEmpty le) = "[ " ++ show le ++ " ]"


data ListExpr
    = LESingle Term | LESeq Term ListExpr | LEHead Term Term
  deriving (Eq, Ord, Read)

instance Show ListExpr where
  show (LESingle t) = show t
  show (LESeq t le) = show t ++ ", " ++ show le
  show (LEHead h t) = show t ++ " | " ++ show t


data Constant = Number Integer | Atom Name
  deriving (Eq, Ord, Read)

instance Show Constant where
  show (Number n) = show n
  show (Atom a) = show a
