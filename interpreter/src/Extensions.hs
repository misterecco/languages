module Extensions where

import AbsProlog
import Db
import Unifier

import Control.Monad.Except


zero :: Integer
zero = 0


failure :: ExceptMaybeMonad [Subst]
failure = ExceptT Nothing


calculate :: Term -> ExceptMaybeMonad Integer
calculate c@(Const (Number n)) = return n
calculate (OpArAdd t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  return $ n1 + n2
calculate (OpArSub t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  return $ n1 - n2
calculate (OpArMul t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  return $ n1 * n2
calculate (OpArNeg t) = do
  n <- calculate t
  return $ (-1) * n
calculate (OpArDiv t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  if n2 == zero then throwError "Division by 0"
    else return $ n1 `quot` n2
calculate (OpArMod t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  if n2 == zero then throwError "Modulo division by 0"
    else return $ n1 `mod` n2
calculate t = throwError $ "Expected arithmetic expression or number, found: " ++ show t


calculatePair :: Term -> Term -> ExceptMaybeMonad (Integer, Integer)
calculatePair t1 t2 = do
  n1 <- calculate t1
  n2 <- calculate t2
  return (n1, n2)


check :: Term -> ExceptMaybeMonad [Subst]
check (OpUnifies t1 t2) = do
  let s1 = unify t1 t2
  if null s1 then failure else return s1
check (OpNotUnifies t1 t2) = do
  let s1 = unify t1 t2
  if null s1 then return [] else failure
check (OpEqual t1 t2) = if t1 == t2 then return [] else failure
check (OpNotEqual t1 t2) = if t1 /= t2 then return [] else failure
check (OpArIs t1 t2) = do
  num <- calculate t2
  let s1 = unify t1 (Const $ Number num)
  if null s1 then failure else return s1
check (OpArEqual t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  if n1 == n2 then return [] else failure
check (OpArNotEqual t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  if n1 /= n2 then return [] else failure
check (OpArLt t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  if n1 < n2 then return [] else failure
check (OpArLte t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  if n1 <= n2 then return [] else failure
check (OpArGt t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  if n1 > n2 then return [] else failure
check (OpArGte t1 t2) = do
  (n1, n2) <- calculatePair t1 t2
  if n1 >= n2 then return [] else failure
check t = throwError $ "Unexpected term: " ++ show t
