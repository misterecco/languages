module HOF where

a :: Integer
a = sum $ takeWhile (<10000) $ filter odd $ map (^ 2) [1..]

b :: Integer
b = sum $ takeWhile (<10000) $ [n^2 | n <- [1..], odd (n^2)]


chain :: (Integral a) => a -> [a]
chain 1 = [1]
chain n
  | even n = n : chain (n `div` 2)
  | odd n  = n : chain (n * 3 + 1)


numLongChains :: Integer
numLongChains = fromIntegral $ length $ filter isLong $ map chain [1..100]
  where isLong xs = length xs > 15
