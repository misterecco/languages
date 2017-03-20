import Tree

main = interact smain

smain :: String -> String
smain input = show $ sort $ read input

sort :: [Int] -> [Int]
sort = toList . fromList
