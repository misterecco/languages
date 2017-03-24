module M where

applyMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
applyMaybe Nothing _ = Nothing
applyMaybe (Just x) f = f x


-- instance Monad Maybe where
--   return x = Just x
--   Nothing >>= f = Nothing
--   Just x >>= f = f x
--   fail _ = Nothing


type Birds = Int
type Pole = (Birds, Birds)


landLeft :: Birds -> Pole -> Maybe Pole
landLeft n (left, right)
  | abs ((left + n) - right) < 4 = Just (left + n, right)
  | otherwise = Nothing

landRight :: Birds -> Pole -> Maybe Pole
landRight n (left, right)
  | abs ((right + n) - left) < 4 = Just (left, right + n)
  | otherwise = Nothing

banana :: Pole -> Maybe Pole
banana _ = Nothing


(-:) :: t1 -> (t1 -> t) -> t
x -: f = f x


foo :: Maybe String
-- foo = Just (3::Int)   >>= (\x ->
      -- Just "1" >>= (\y ->
      -- Just (show x ++ y)))

foo = do
  x <- Just (3::Int)
  y <- Just "!"
  Just (show x ++ y)


justH :: Maybe Char
justH = do
  (x:_) <- Just "hello"
  return x
