import Control.Applicative


main = do
  a <- myAction
  putStrLn $ "The two lines concatenated turn out to be: " ++ a


myAction :: IO String
myAction = (++) <$> getLine <*> getLine
