module Lab02 where

-- Zadanie 6
-- Trójki pitagorejskie

triads :: Int -> [(Int, Int, Int)]
triads n = notMultiplied $ filter pyth $ triples n

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

primes :: [Int]
primes = [n | n<-[2..], all ((> 0).rem n) [2..n-1]]

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

-- Silnia
factorial :: Int -> Int
factorial n = foo n 1
  where
    foo 0 x = x
    foo x acc = foo (x-1) (x * acc)


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
