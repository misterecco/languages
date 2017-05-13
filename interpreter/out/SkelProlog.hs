module SkelProlog where

-- Haskell module generated by the BNF converter

import AbsProlog
import ErrM
type Result = Err String

failure :: Show a => a -> Result
failure x = Bad $ "Undefined case: " ++ show x

transName :: Name -> Result
transName x = case x of
  Name string -> failure x
transVariable :: Variable -> Result
transVariable x = case x of
  Variable string -> failure x
transProgram :: Program -> Result
transProgram x = case x of
  Program1 sentences -> failure x
transSentence :: Sentence -> Result
transSentence x = case x of
  SentenceClause clause -> failure x
  Query term -> failure x
transClause :: Clause -> Result
transClause x = case x of
  Rule term terms -> failure x
  UnitClause term -> failure x
transTerm :: Term -> Result
transTerm x = case x of
  OpNegate term -> failure x
  OpUnifies term1 term2 -> failure x
  OpNotUnifies term1 term2 -> failure x
  OpEqual term1 term2 -> failure x
  OpNotEqual term1 term2 -> failure x
  OpArIs term1 term2 -> failure x
  OpArEqual term1 term2 -> failure x
  OpArNotEqual term1 term2 -> failure x
  OpArLt term1 term2 -> failure x
  OpArGt term1 term2 -> failure x
  OpArLte term1 term2 -> failure x
  OpArGte term1 term2 -> failure x
  OpArAdd term1 term2 -> failure x
  OpArSub term1 term2 -> failure x
  OpArMul term1 term2 -> failure x
  OpArDiv term1 term2 -> failure x
  OpArMod term1 term2 -> failure x
  OpArNeg term -> failure x
  Funct name terms -> failure x
  Var variable -> failure x
  Const constant -> failure x
  List lst -> failure x
transLst :: Lst -> Result
transLst x = case x of
  ListEmpty -> failure x
  ListNonEmpty listexpr -> failure x
  ListChar string -> failure x
transListExpr :: ListExpr -> Result
transListExpr x = case x of
  LESingle term -> failure x
  LESeq term listexpr -> failure x
  LEHead term1 term2 -> failure x
transConstant :: Constant -> Result
transConstant x = case x of
  Number integer -> failure x
  Atom name -> failure x

