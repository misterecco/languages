main :: IO ()
main = interact splitLines

maxLength :: Int
maxLength = 30

splitLines :: String -> String
splitLines input = unlines $ joinWords $ words input

joinWords :: [String] -> [String]
joinWords lst = foo lst [] []
  where
    foo [] wacc acc = reverse (unwords (reverse wacc) : acc)
    foo (w:ws) wacc acc = if lLength (w : wacc) <= maxLength
      then foo ws (w : wacc) acc
      else foo ws [w] (unwords (reverse wacc) : acc)

lLength :: [String] -> Int
lLength lst = sum $ map length lst
