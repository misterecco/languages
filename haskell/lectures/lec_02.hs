module Lec02 where

-- import Prelude hiding(Functor(..))

data TakNie = Tak | Nie
  deriving (Eq, Show)

nie :: TakNie -> TakNie
nie Tak = Nie
nie Nie = Tak


data Tree a = Leaf a | Branch (Tree a) (Tree a)

mapTree :: (a -> b) -> Tree a -> Tree b
mapTree f (Leaf a) = Leaf (f a)
mapTree f (Branch l r) = Branch (m l) (m r)
  where
    m = mapTree f


safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

safeHead2 :: [a] -> Either String a
safeHead2 [] = Left "Empty list"
safeHead2 (x:_) = Right x


type Name = String
type Possibly = Either Name

safeHead3 :: [a] -> Possibly a
safeHead3 [] = Left "Empty list"
safeHead3 (x:_) = Right x


-- data Point = Pt Float Float
-- pointx :: Point -> Float
-- pointx (Pt x _) = x
-- pointy :: Point -> Float
-- pointy (Pt _ y) = y
data Point = Pt {pointx, pointy :: Float}


newtype Identity a = Identity { runIdentity :: a }
  deriving (Eq, Show)


el :: Eq t => t -> [t] -> Bool
el _ [] = False
el x (y:ys) = (x == y) || el x ys


class Por a where
  (===) :: a -> a -> TakNie
  (=/=) :: a -> a -> TakNie

instance Por TakNie where
  Tak === Tak = Tak
  Nie === Nie = Tak
  _   ===  _  = Nie

  a =/= b = nie $ a === b


class (Functor f) => Applicative f
  where
    pure  :: a -> f a
    (<$>) :: f (a -> b) -> f a -> f b
