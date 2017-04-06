
module L where

data List a = Empty | Cons a (List a)
  deriving (Show, Read, Eq, Ord)

type ListZipper a = ([a], [a])

goForward :: ListZipper a -> ListZipper a
goForward (x:xs, bs) = (xs, x:bs)
goForward ([], _) = error "The list is empty"

goBack :: ListZipper a -> ListZipper a
goBack (xs, x:bs) = (x:xs, bs)
goBack (_, []) = error "Already at the head"
