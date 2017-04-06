module U where

import Control.Monad.Writer
import Data.List

keepSmall :: Int -> Writer [String] Bool
keepSmall x
  | x < 4 = do
    tell ["Keeping " ++ show x]
    return True
  | otherwise = do
    tell [show x ++ " is too large, throwing it away"]
    return False


powerset :: [a] -> [[a]]
powerset = filterM (const [True, False])

s :: Int
s = sum [2,8,3,1]


binSmalls :: Int -> Int -> Maybe Int
binSmalls acc x
  | x > 9 = Nothing
  | otherwise = Just (acc + x)
