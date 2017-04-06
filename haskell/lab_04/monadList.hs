module ML where

allPairs :: [a] -> [a] -> [[a]]
-- allPairs xs ys = [[x, y] | x <- xs, y <- ys]
allPairs xs ys = do
  x <- xs
  y <- ys
  return [x, y]

allCombinations :: [[a]] -> [[a]]
allCombinations = sequence
