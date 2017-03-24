import Control.Applicative

main = do
  a <- myAction
  putStrLn $ "The two lines concatenated turn out to be: " ++ a


myAction :: IO String
myAction = (++) <$> getLine <*> getLine

-- sequenceA :: (Applicative f) => [f a] -> f [a]
-- sequenceA [] = pure []
-- sequenceA (x:xs) = (:) <$> x <*> sequenceA xs


newtype Pair b a = Pair { getPair :: (a, b)}

instance Functor (Pair c) where
  fmap f (Pair (x, y)) = Pair (f x, y)
