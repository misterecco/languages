main :: IO ()
main = interact smain

maxn :: Integer
maxn = 30

licz :: Integer -> String -> String
licz _ [] = []

licz n s@(c:cs)
  | n == 0      = '\n' : licz maxn s
  | otherwise   = c : if c == '\n' then
                       licz maxn cs
                      else
                       licz (n-1) cs

smain :: String -> String
smain = licz maxn
