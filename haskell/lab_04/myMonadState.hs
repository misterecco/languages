module MS where

import Control.Monad.State
import Data.Map as M

type Var = String

data Exp
  = EInt Int
  | EOp Op Exp Exp
  | EVar Var
  | ELet Var Exp Exp

data Op = OpAdd | OpMul | OpSub

evalExp :: Exp -> Int
evalExp e = evalState (eval e) empty

eval :: Exp -> State (Map Var Int) Int
eval (EInt x) = return x

eval (EVar var) = do
  env <- get
  case M.lookup var env of
    Nothing -> undefined
    Just x -> return x

eval (EOp op e1 e2) = do
  x1 <- eval e1
  x2 <- eval e2
  case op of
    OpAdd -> return (x1 + x2)
    OpMul -> return (x1 * x2)
    OpSub -> return (x1 - x2)

eval (ELet var e1 e2) = do
  x1 <- eval e1
  env <- get
  put $ insert var x1 env
  eval e2


test :: Exp
test = ELet "x" (ELet "y" (EOp OpAdd (EInt 6) (EInt 9))
                      (EOp OpSub y (EInt 1)))
                (EOp OpMul x (EInt 3))
    where x = EVar "x"
          y = EVar "y"


data Stmt
  = SSkip
  | SAssign Var Exp
  | SSequence Stmt Stmt
  | SIfThenElse Exp Stmt Stmt
  | SWhile Exp Stmt

exec :: Stmt -> State (Map Var Int) ()
exec SSkip = return ()

exec (SAssign var e) = do
  n <- eval e
  env <- get
  put $ insert var n env
  return ()

exec (SSequence st1 st2) = do
  exec st1
  exec st2

exec (SIfThenElse e s1 s2) = do
  n <- eval e
  if n == 0 then exec s1 else exec s2

exec (SWhile e st) = do
  n <- eval e
  if n == 0 then exec st else return ()

toString :: Map Var Int -> [String]
toString = foldrWithKey foo []
  where
    foo var val acc = (var ++ " = " ++ show val) : acc

execStmt :: Stmt -> IO ()
execStmt x = do
  let s = execState (exec x) empty
  mapM_ putStrLn (toString s)


s1 :: Stmt
s1 = SSequence
  ( SSequence
    ( SAssign "x" (EInt 10) )
    ( SAssign "y" (EInt 20) )
  )
  ( SSequence
    ( SAssign "z" (EInt 50) )
    ( SAssign "a" ( EOp OpAdd (EVar "z") (EInt 10) ) )
  )
