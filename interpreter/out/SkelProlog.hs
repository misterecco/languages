module SkelProlog where

-- Haskell module generated by the BNF converter

import AbsProlog
import ErrM
type Result = Err String

failure :: Show a => a -> Result
failure x = Bad $ "Undefined case: " ++ show x

transVariable :: Variable -> Result
transVariable x = case x of
  Variable string -> failure x
transWoord :: Woord -> Result
transWoord x = case x of
  Woord string -> failure x
transProgram :: Program -> Result
transProgram x = case x of
  Program1 sentences -> failure x
transSentence :: Sentence -> Result
transSentence x = case x of
  SentenceClause clause -> failure x
  SentenceDirective directive -> failure x
  SentenceQuery query -> failure x
transClause :: Clause -> Result
transClause x = case x of
  ClauseRule rule -> failure x
  ClauseUnit_clause unitclause -> failure x
transRule :: Rule -> Result
transRule x = case x of
  Rule1 head body -> failure x
transUnit_clause :: Unit_clause -> Result
transUnit_clause x = case x of
  Unit_clauseHead head -> failure x
transDirective :: Directive -> Result
transDirective x = case x of
  Directive1 body -> failure x
transQuery :: Query -> Result
transQuery x = case x of
  Query1 body -> failure x
transHead :: Head -> Result
transHead x = case x of
  HeadGoal goal -> failure x
transBody :: Body -> Result
transBody x = case x of
  Body1 -> failure x
  Body2 body -> failure x
  Body3 body1 body2 -> failure x
  Body4 body1 body2 body3 -> failure x
  Body0Goal goal -> failure x
transGoal :: Goal -> Result
transGoal x = case x of
  GoalTerm term -> failure x
transTerm :: Term -> Result
transTerm x = case x of
  Term71 term1 term2 -> failure x
  Term72 term1 term2 -> failure x
  Term73 term1 term2 -> failure x
  Term74 term1 term2 -> failure x
  Term75 term1 term2 -> failure x
  Term76 term1 term2 -> failure x
  Term77 term1 term2 -> failure x
  Term78 term1 term2 -> failure x
  Term79 term1 term2 -> failure x
  Term710 term1 term2 -> failure x
  Term711 term1 term2 -> failure x
  Term51 term1 term2 -> failure x
  Term52 term1 term2 -> failure x
  Term41 term1 term2 -> failure x
  Term42 term1 term2 -> failure x
  Term43 term1 term2 -> failure x
  Term21 term -> failure x
  Term01 functoor arguments -> failure x
  Term02 term -> failure x
  Term0List list -> failure x
  Term0String string -> failure x
  Term0Constant constant -> failure x
  Term0Variable variable -> failure x
transArgument :: Argument -> Result
transArgument x = case x of
  ArgumentTerm9 term -> failure x
transList :: List -> Result
transList x = case x of
  List1 -> failure x
  List2 listexpr -> failure x
transList_Expr :: List_Expr -> Result
transList_Expr x = case x of
  List_ExprTerm9 term -> failure x
  List_Expr1 term listexpr -> failure x
  List_Expr2 term1 term2 -> failure x
transConstant :: Constant -> Result
transConstant x = case x of
  ConstantAtom atom -> failure x
  ConstantNumber number -> failure x
transNumber :: Number -> Result
transNumber x = case x of
  NumberInteger integer -> failure x
transAtom :: Atom -> Result
transAtom x = case x of
  AtomName name -> failure x
transFunctoor :: Functoor -> Result
transFunctoor x = case x of
  FunctoorName name -> failure x
transName :: Name -> Result
transName x = case x of
  NameWoord woord -> failure x

