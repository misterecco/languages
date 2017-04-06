module T where

data Tree a = Empty | Node a (Tree a) (Tree a)
  deriving Show

freeTree :: Tree Char
freeTree =
    Node 'P'
        (Node 'O'
            (Node 'L'
                (Node 'N' Empty Empty)
                (Node 'T' Empty Empty)
            )
            (Node 'Y'
                (Node 'S' Empty Empty)
                (Node 'A' Empty Empty)
            )
        )
        (Node 'L'
            (Node 'W'
                (Node 'C' Empty Empty)
                (Node 'R' Empty Empty)
            )
            (Node 'A'
                (Node 'A' Empty Empty)
                (Node 'C' Empty Empty)
            )
        )


data Direction = L | R deriving (Show)
type Directions = [Direction]

changeToP :: Directions -> Tree Char -> Tree Char
changeToP (L:ds) (Node x l r) = Node x (changeToP ds l) r
changeToP (R:ds) (Node x l r) = Node x l (changeToP ds r)
changeToP [] (Node _ l r) = Node 'P' l r
changeToP _ Empty = Empty

elemAt :: Directions -> Tree a -> a
elemAt (L:ds) (Node _ l _) = elemAt ds l
elemAt (R:ds) (Node _ _ r) = elemAt ds r
elemAt [] (Node x _ _) = x
elemAt _ Empty = error "Wrong directions"


-- type Breadcrumbs = [Direction]
--
-- goLeft :: (Tree a, Breadcrumbs) -> (Tree a, Breadcrumbs)
-- goLeft (Node _ l _, bs) = (l, L:bs)
-- goLeft (Empty, _) = error "Empty tree"
--
-- goRight :: (Tree a, Breadcrumbs) -> (Tree a, Breadcrumbs)
-- goRight (Node _ _ r, bs) = (r, R:bs)
-- goRight (Empty, _) = error "Empty tree"


(-:) :: t1 -> (t1 -> t) -> t
x -: f = f x


data Crumb a = LeftCrumb a (Tree a) | RightCrumb a (Tree a)
  deriving (Show)

type Breadcrumbs a = [Crumb a]

goLeft :: (Tree a, Breadcrumbs a) -> (Tree a, Breadcrumbs a)
goLeft (Node x l r, bs) = (l, LeftCrumb x r:bs)
goLeft (Empty, _) = error "Empty tree"

goRight :: (Tree a, Breadcrumbs a) -> (Tree a, Breadcrumbs a)
goRight (Node x l r, bs) = (r, RightCrumb x l:bs)
goRight (Empty, _) = error "Empty tree"

goUp :: (Tree a, Breadcrumbs a) -> (Tree a, Breadcrumbs a)
goUp (t, LeftCrumb x r:bs) = (Node x t r, bs)
goUp (t, RightCrumb x l:bs) = (Node x l t, bs)
goUp (_, []) = error "Already in the root"


type Zipper a = (Tree a, Breadcrumbs a)


modify :: (a -> a) -> Zipper a -> Zipper a
modify f (Node x l r, bs) = (Node (f x) l r, bs)
modify _ (Empty, bs) = (Empty, bs)


attach :: Tree a -> Zipper a -> Zipper a
attach t (_, bs) = (t, bs)


topMost :: Zipper a -> Zipper a
topMost (t, []) = (t, [])
topMost z = topMost (goUp z)
