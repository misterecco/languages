module Unifier where

import AbsProlog

import Control.Monad.Except

type ExceptMaybeMonad = ExceptT String Maybe
type ExceptMonad = Except String
type Subst = Variable -> Term
data Prooftree = Done Subst | Choice [Prooftree]


failure :: [Subst]
failure = []


nullSubst :: Subst
nullSubst = Var


baseSubst :: [Subst]
baseSubst = [nullSubst]


(->>) :: Variable -> Term -> Subst
(->>) var t v | v == var = t
              | otherwise = Var v


(@@) :: Subst -> Subst -> Subst
s1 @@ s2 = apply s1 . s2


apply :: Subst -> Term -> Term
apply s = foldTerm (applyToVar s)


mapApply :: Subst -> [Term] -> [Term]
mapApply = map . apply


applyToVar :: Subst -> Term -> Term
applyToVar s (Var v@(Variable _)) = s v
applyToVar s t = t


foldTerm :: (Term -> Term) -> Term -> Term
foldTerm f v@(Var _) = f v
foldTerm f c@(Const _) = c
foldTerm f (Funct name terms) = Funct name $ map (foldTerm f) terms
foldTerm f (List l) = List $ foldList l
  where foldList ListEmpty = ListEmpty
        foldList (ListChar s) = ListChar s
        foldList (ListNonEmpty le) = ListNonEmpty $ foldLE le
        foldLE (LESingle t) = LESingle $ foldTerm f t
        foldLE (LESeq t le) = LESeq (foldTerm f t) (foldLE le)
        foldLE (LEHead h t) = LEHead (foldTerm f h) (foldTerm f t)
foldTerm f (OpNegate t) = OpNegate $ foldTerm f t
foldTerm f (OpArNeg t) = OpArNeg $ foldTerm f t
foldTerm f (OpUnifies t1 t2) = OpUnifies (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpNotUnifies t1 t2) = OpNotUnifies (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpEqual t1 t2) = OpEqual (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpNotEqual t1 t2) = OpNotEqual (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArIs t1 t2) = OpArIs (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArEqual t1 t2) = OpArEqual (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArNotEqual t1 t2) = OpArNotEqual (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArLt t1 t2) = OpArLt (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArGt t1 t2) = OpArGt (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArLte t1 t2) = OpArLte (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArGte t1 t2) = OpArGte (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArAdd t1 t2) = OpArAdd (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArSub t1 t2) = OpArSub (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArMul t1 t2) = OpArMul (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArDiv t1 t2) = OpArDiv (foldTerm f t1) (foldTerm f t2)
foldTerm f (OpArMod t1 t2) = OpArMod (foldTerm f t1) (foldTerm f t2)


unify :: Term -> Term -> [Subst]
unify (Var x) (Var y) = if x == y then baseSubst else [x ->> Var y]
unify (Var x) l@(List _) = [x ->> l]
unify (Var x) c@(Const _) = [x ->> c]
unify (Var x) f@(Funct _ _) = [x ->> f]
unify (Var x) _ = failure
unify t v@(Var x) = unify v t
unify (Funct name1 terms1) (Funct name2 terms2) =
  if name1 == name2 then listUnify terms1 terms2 else failure
unify (List l1) (List l2) = unifyLists l1 l2
unify (Const x) (Const y) = if x == y then baseSubst else failure
unify _ _ = failure
-- TODO: unify other types of terms


unifyLists :: Lst -> Lst -> [Subst]
unifyLists ListEmpty ListEmpty = baseSubst
unifyLists (ListChar s1) (ListChar s2) =
  if s1 == s2 then baseSubst else failure
unifyLists (ListChar s) ListEmpty = if null s then baseSubst else failure
unifyLists ListEmpty (ListChar s) = unifyLists (ListChar s) ListEmpty
unifyLists (ListChar s) le@(ListNonEmpty _) = if null s then failure
  else unifyLists (ListNonEmpty $ LEHead (List $ ListChar [head s]) (List $ ListChar $ tail s)) le
unifyLists le@(ListNonEmpty _) lc@(ListChar _) = unifyLists lc le
unifyLists (ListNonEmpty le1) (ListNonEmpty le2) = unifyLE le1 le2 where
  unifyLE (LESingle t1) (LESingle t2) = unify t1 t2
  unifyLE (LESeq t1 le1) (LESeq t2 le2) =
    listUnify [t1, List $ ListNonEmpty le1] [t2, List $ ListNonEmpty le2]
  unifyLE (LEHead h1 t1) (LEHead h2 t2) = listUnify [t1, h1] [t2, h2]
  unifyLE (LESingle t1) (LEHead h t) = listUnify [t1, List ListEmpty] [h, t]
  unifyLE le1@(LEHead _ _) le2@(LESingle _) = unifyLE le2 le1
  unifyLE (LESeq t1 t2) (LEHead h t) = listUnify [t1, List $ ListNonEmpty t2] [h, t]
  unifyLE leh@(LEHead _ _) les@(LESeq _ _) = unifyLE les leh
  unifyLE _ _ = failure
unifyLists _ _ = failure


listUnify :: [Term] -> [Term] -> [Subst]
listUnify [] [] = [nullSubst]
listUnify (t:ts) (r:rs) =
  [u2 @@ u1 | u1 <- unify t r,
                     let uu = listUnify (mapApply u1 ts) (mapApply u1 rs),
                     u2 <- uu]
listUnify _ _ = failure
