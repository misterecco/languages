module W where

import Control.Monad.Writer
import Data.Monoid


isBigGang :: Int -> (Bool, String)
isBigGang x = (x > 9, "Compared gang size to 9.")


applyLog :: (Monoid m) => (a,m) -> (a -> (b,m)) -> (b,m)
applyLog (x, lg) f = let (y, newLog) = f x in (y, lg `mappend` newLog)


type Food = String
type Price = Sum Int


addDrink :: Food -> (Food, Price)
addDrink "beans" = ("milk", Sum 25)
addDrink "jerky" = ("whiskey", Sum 99)
addDrink _ = ("beer", Sum 30)


logNumber :: Int -> Writer [String] Int
logNumber x = Writer (x, ["Got number: " ++ show x])
