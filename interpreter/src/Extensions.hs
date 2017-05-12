module Extensions where

import AbsProlog
import Db
import Unifier

import Control.Monad.Except


zero :: Term
zero = Const $ Number 0


calculate :: Term -> ExceptMaybeMonad Term
calculate (OpArAdd t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  return $ Const $ Number (n1 + n2)
calculate (OpArSub t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  return $ Const $ Number (n1 - n2)
calculate (OpArMul t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  return $ Const $ Number (n1 * n2)
calculate (OpArNeg t) = do
  Const (Number n) <- calculate t
  return $ Const $ Number $ (-1) * n
calculate (OpArDiv t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  if t2 == zero then throwError "Division by 0"
    else return $ Const $ Number (n1 `quot` n2)
calculate (OpArMod t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  if t2 == zero then throwError "Modulo division by 0"
    else return $ Const $ Number (n1 `mod` n2)
calculate c@(Const (Number _)) = return c
calculate t = throwError $ "Expected arithmetic expression or constant, found: " ++ show t


check :: Database -> Term -> ExceptMaybeMonad [Subst]
check db (OpUnifies t1 t2) = do
  let s1 = unify t1 t2
  if null s1 then ExceptT Nothing else return s1
check db (OpNotUnifies t1 t2) = do
  let s1 = unify t1 t2
  if null s1 then return [] else ExceptT Nothing
check db (OpEqual t1 t2) = if t1 == t2 then return [] else ExceptT Nothing
check db (OpNotEqual t1 t2) = if t1 /= t2 then return [] else ExceptT Nothing
check db (OpNegate t) = return []
check db (OpArIs t1 t2) = do
  num <- calculate t2
  return $ unify t1 num
check db (OpArEqual t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  if n1 == n2 then return [] else ExceptT Nothing
check db (OpArNotEqual t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  if n1 /= n2 then return [] else ExceptT Nothing
check db (OpArLt t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  if n1 < n2 then return [] else ExceptT Nothing
check db (OpArLte t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  if n1 <= n2 then return [] else ExceptT Nothing
check db (OpArGt t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  if n1 > n2 then return [] else ExceptT Nothing
check db (OpArGte t1 t2) = do
  Const (Number n1) <- calculate t1
  Const (Number n2) <- calculate t2
  if n1 >= n2 then return [] else ExceptT Nothing
check db t = throwError $ "Unexpected term: " ++ show t
