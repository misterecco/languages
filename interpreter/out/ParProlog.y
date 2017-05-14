-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParProlog where
import AbsProlog
import LexProlog
import ErrM

}

%name pProgram Program
-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype {Token}
%token
  '(' { PT _ (TS _ 1) }
  ')' { PT _ (TS _ 2) }
  '*' { PT _ (TS _ 3) }
  '+' { PT _ (TS _ 4) }
  ',' { PT _ (TS _ 5) }
  '-' { PT _ (TS _ 6) }
  '.' { PT _ (TS _ 7) }
  '/' { PT _ (TS _ 8) }
  ':-' { PT _ (TS _ 9) }
  '<' { PT _ (TS _ 10) }
  '=' { PT _ (TS _ 11) }
  '=:=' { PT _ (TS _ 12) }
  '=<' { PT _ (TS _ 13) }
  '==' { PT _ (TS _ 14) }
  '=\\=' { PT _ (TS _ 15) }
  '>' { PT _ (TS _ 16) }
  '>=' { PT _ (TS _ 17) }
  '?-' { PT _ (TS _ 18) }
  '[' { PT _ (TS _ 19) }
  '\\+' { PT _ (TS _ 20) }
  '\\=' { PT _ (TS _ 21) }
  '\\==' { PT _ (TS _ 22) }
  ']' { PT _ (TS _ 23) }
  'is' { PT _ (TS _ 24) }
  'mod' { PT _ (TS _ 25) }
  '|' { PT _ (TS _ 26) }

L_quoted { PT _ (TL $$) }
L_integ  { PT _ (TI $$) }
L_Name { PT _ (T_Name $$) }
L_Variable { PT _ (T_Variable $$) }


%%

String  :: { String }  : L_quoted {  $1 }
Integer :: { Integer } : L_integ  { (read ( $1)) :: Integer }
Name    :: { Name} : L_Name { Name ($1)}
Variable    :: { Variable} : L_Variable { Variable ($1)}

Program :: { Program }
Program : ListSentence { AbsProlog.Program1 (reverse $1) }
ListSentence :: { [Sentence] }
ListSentence : {- empty -} { [] }
             | ListSentence Sentence '.' { flip (:) $1 $2 }
Sentence :: { Sentence }
Sentence : Clause { AbsProlog.SentenceClause $1 }
         | '?-' ListTerm { AbsProlog.Query $2 }
Clause :: { Clause }
Clause : Term ':-' ListTerm { AbsProlog.Rule $1 $3 }
       | Term { AbsProlog.UnitClause $1 }
ListTerm :: { [Term] }
ListTerm : Term { (:[]) $1 } | Term ',' ListTerm { (:) $1 $3 }
Term :: { Term }
Term : Term12 { $1 }
Term12 :: { Term }
Term12 : Term11 { $1 }
Term11 :: { Term }
Term11 : Term10 { $1 }
Term10 :: { Term }
Term10 : Term9 { $1 }
Term9 :: { Term }
Term9 : Term8 { $1 } | '\\+' Term9 { AbsProlog.OpNegate $2 }
Term8 :: { Term }
Term8 : Term7 { $1 }
Term7 :: { Term }
Term7 : Term6 { $1 }
      | Term6 '=' Term6 { AbsProlog.OpUnifies $1 $3 }
      | Term6 '\\=' Term6 { AbsProlog.OpNotUnifies $1 $3 }
      | Term6 '==' Term6 { AbsProlog.OpEqual $1 $3 }
      | Term6 '\\==' Term6 { AbsProlog.OpNotEqual $1 $3 }
      | Term6 'is' Term6 { AbsProlog.OpArIs $1 $3 }
      | Term6 '=:=' Term6 { AbsProlog.OpArEqual $1 $3 }
      | Term6 '=\\=' Term6 { AbsProlog.OpArNotEqual $1 $3 }
      | Term6 '<' Term6 { AbsProlog.OpArLt $1 $3 }
      | Term6 '>' Term6 { AbsProlog.OpArGt $1 $3 }
      | Term6 '=<' Term6 { AbsProlog.OpArLte $1 $3 }
      | Term6 '>=' Term6 { AbsProlog.OpArGte $1 $3 }
Term6 :: { Term }
Term6 : Term5 { $1 }
Term5 :: { Term }
Term5 : Term4 { $1 }
      | Term5 '+' Term4 { AbsProlog.OpArAdd $1 $3 }
      | Term5 '-' Term4 { AbsProlog.OpArSub $1 $3 }
Term4 :: { Term }
Term4 : Term3 { $1 }
      | Term4 '*' Term3 { AbsProlog.OpArMul $1 $3 }
      | Term4 '/' Term3 { AbsProlog.OpArDiv $1 $3 }
      | Term4 'mod' Term3 { AbsProlog.OpArMod $1 $3 }
Term3 :: { Term }
Term3 : Term2 { $1 }
Term2 :: { Term }
Term2 : Term1 { $1 } | '-' Term2 { AbsProlog.OpArNeg $2 }
Term1 :: { Term }
Term1 : Term0 { $1 }
Term0 :: { Term }
Term0 : '(' Term12 ')' { $2 }
      | Name '(' ListTerm9 ')' { AbsProlog.Funct $1 $3 }
      | Variable { AbsProlog.Var $1 }
      | Constant { AbsProlog.Const $1 }
      | Lst { AbsProlog.List $1 }
ListTerm9 :: { [Term] }
ListTerm9 : Term9 { (:[]) $1 } | Term9 ',' ListTerm9 { (:) $1 $3 }
Lst :: { Lst }
Lst : '[' ']' { AbsProlog.ListEmpty }
    | '[' ListExpr ']' { AbsProlog.ListNonEmpty $2 }
    | String { AbsProlog.ListChar $1 }
ListExpr :: { ListExpr }
ListExpr : Term9 { AbsProlog.LESingle $1 }
         | Term9 ',' ListExpr { AbsProlog.LESeq $1 $3 }
         | Term9 '|' Term9 { AbsProlog.LEHead $1 $3 }
Constant :: { Constant }
Constant : Integer { AbsProlog.Number $1 }
         | Name { AbsProlog.Atom $1 }
{

returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    _ -> " before " ++ unwords (map (id . prToken) (take 4 ts))

myLexer = tokens
}

