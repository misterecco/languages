module Tree where

data Tree a = Empty | Node a (Tree a) (Tree a)
  deriving (Ord)


instance Show a => Show (Tree a) where
  show Empty = "*"
  show (Node a lt rt) = "(" ++ show lt ++ "," ++ show a ++ "," ++ show rt ++ ")"


instance Eq a => Eq  (Tree a) where
  (==) t1 t2 = case (t1, t2) of
    (Empty, Empty) -> True
    (Node a alt art, Node b blt brt) ->
      a == b && ((alt == blt && art == brt) || (alt == brt && blt == art))
    (_, _) -> True


instance Functor Tree where
  fmap _ Empty = Empty
  fmap f (Node a lt rt) = Node (f a) (fmap f lt) (fmap f rt)


toList :: Tree a -> [a]
toList Empty = []
toList (Node a lt rt) = toList lt ++ a : toList rt

toList2 :: Tree a -> [a]
toList2 t = dolacz t []
  where
    dolacz :: Tree a -> [a] -> [a]
    dolacz Empty reszta = reszta
    dolacz (Node x l r) reszta = dolacz l ([x] ++ dolacz r reszta)


insert :: (Ord a) => a -> Tree a -> Tree a
insert a Empty = Node a Empty Empty
insert a (Node b lt rt)
  | a <= b = Node b (insert a lt) rt
  | otherwise = Node b lt (insert a rt)


contains :: (Ord a) => a -> Tree a -> Bool
contains _ Empty = False
contains a (Node b lt rt)
  | a == b = True
  | a < b = contains a lt
  | otherwise = contains a rt


fromList :: (Ord a) => [a] -> Tree a
fromList = foldr insert Empty


-- sort :: (Ord a) => [a] -> [a]
-- sort = toList . fromList
