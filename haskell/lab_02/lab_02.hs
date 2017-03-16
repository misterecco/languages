module Lab02 where

-- Zadanie 6
-- Trójki pitagorejskie

triads :: Int -> [(Int, Int, Int)]
triads n = notMultiplied $ filter pyth $ triples n

triads2 :: Int -> [(Int, Int, Int)]
triads2 n =
  [(a, b, c) | a <- [1..n], b <- [a..n], c <- [b..n], a*a + b*b == c*c, (a `gcd` b) `gcd` c == 1]

triples :: Int -> [(Int, Int, Int)]
triples n = [(x, y, z) | x <- [1..n],
                         y <- [1..n],
                         z <- [1..n],
                         (x < y) && (y < z)]

pyth :: (Int, Int, Int) -> Bool
pyth (x, y, z) = x * x + y * y == z * z

notMultiplied :: [(Int, Int, Int)] -> [(Int, Int, Int)]
notMultiplied [] = []
notMultiplied (x:xs) = x:zs
  where
    (a, b, c) = x
    ys = filter (\(a1, b1, c1) -> not(a1 * b == b1 * a && b1 * c == c1 * b)) xs
    zs = notMultiplied ys


-- Zadanie 7
-- Liczby pierwsze

primes :: [Integer]
primes = [n | n<-[2..], all ((> 0).rem n) [2..n-1]]

prim :: [Integer]
prim = sieve [2..] where
  sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]

-- Liczby Fibonacciego

fib1 :: Int -> Int
fib1 n
  | n == 0 = 0
  | n == 1 = 1
  | n >= 2 = fib1 (n-1) + fib1 (n-2)
  | otherwise = 0

fib2 :: Int -> Int
fib2 n = foo n 0 1
  where
    foo 0 x _ = x
    foo x f f1 = foo (x-1) f1 (f + f1)

fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- Silnia
factorial :: Int -> Int
factorial n = foo n 1
  where
    foo 0 x = x
    foo x acc = foo (x-1) (x * acc)

ones :: [Integer]
ones = 1 : ones

nats :: [Integer]
nats = 0 : zipWith (+) ones nats

fact :: [Integer]
fact = 1 : zipWith (*) [1..] fact

factn :: Integer -> Integer
factn n = product [1..n]

-- Zadanie 8

indexOf :: Char -> String -> Maybe Int
indexOf c l = foo l 0
  where
    foo [] _ = Nothing
    foo (x:xs) n
      | c == x = Just n
      | otherwise = foo xs (n+1)


positions :: Char -> String -> [Int]
positions c l = foo l 0 []
  where
    foo [] _ acc = reverse acc
    foo (x:xs) n acc
      | x == c = foo xs (n+1) ((n+1):acc)
      | otherwise = foo xs (n+1) acc

pos :: Char -> String -> [Int]
pos c s = [ i | (d, i) <- zip s [0..], c == d]

ind :: Char -> String -> Maybe Int
ind c s =
  case pos c s of
    [] -> Nothing
    x:_ -> Just x

-- Zadanie 9
digit :: Int -> Char
digit n = iterate succ '0' !! n

-- digit2 d = chr $ ord '0' + d

si :: Int -> String -> String
si n s
  | n == 0 = s
  | otherwise = si (n `div` 10) (digit (n `mod` 10) : s)

showInt :: Int -> String
showInt 0 = "0"
showInt n = si n []

showIntListContent :: [Int] -> String
showIntListContent [] = ""
showIntListContent [n] = showInt n
showIntListContent (n:ns) = showInt n ++ "," ++ showIntListContent ns

showIntList :: [Int] -> String
showIntList ns = "[" ++ showIntListContent ns ++ "]"

showLst :: (a -> String) -> [a] -> String
showLst _ [] = []
showLst f [x] = f x
showLst f (x:xs) = f x ++ "," ++ showLst f xs

-- concat1 = foldr (++) []

-- incAll
incAll :: Num b => [[b]] -> [[b]]
incAll x = let zwieksz = map (+1) in map zwieksz x

silniaFoldl :: (Num b, Enum b) => b -> b
silniaFoldl n = foldl (*) 1 [1..n]
silniaFoldr :: (Num b, Enum b) => b -> b
silniaFoldr n = foldr (*) 1 [1..n]

nubP :: (t -> t -> Bool) -> [t] -> [t]
nubP _ [] = []
nubP p (x:xs) = x : filter (\y -> not (p y x)) (nubP p xs)

nub :: Eq a => [a] -> [a]
nub = nubP (==)

przeplot :: [a] -> [a] -> [a]
przeplot [] xs = xs
przeplot (x:xs) ys = x : przeplot ys xs
