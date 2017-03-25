import System.Environment
import Text.Read


newtype Alpha = Alpha Char
  deriving (Eq)

instance Bounded Alpha where
  minBound = Alpha 'A'
  maxBound = Alpha 'Z'

instance Enum Alpha where
  toEnum = toEnum
  fromEnum = fromEnum

instance Show Alpha where
  show = show


main :: IO ()
main = do
  (filename:args) <- getArgs
  putStrLn $ "Reading from file named: " ++ filename
