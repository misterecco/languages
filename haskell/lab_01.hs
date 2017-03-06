module Lab01 where

-- Zadanie 1

myhead [] = error "Nie ma glowy"
myhead (x:_) = x

mytail [] = error "Nie ma ogona"
mytail (_:xs) = xs

app [] ys = ys
app (x:xs) ys = x : app xs ys

mytake 0 l = []
mytake n [] = []
mytake n (x : xs) = x : mytake (n-1) xs

mydrop0 n [] = []
mydrop0 n l@(x:xs)
  | n == 0 = l
  | otherwise = mydrop0 (n-1) xs

mydrop1 n [] = []
mydrop1 n l
  | n == 0 = l
  | otherwise = mydrop1 (n-1) (tail l)

mydrop2 0 xs = xs
mydrop2 _ [] = []
mydrop2 n (x:xs) = mydrop2 (n-1) xs

odwroc [] = []
odwroc (x:xs) = (odwroc xs)++[x]

odwroc1 xs = rev xs [] where
  rev [] ak = ak
  rev (x:xs) ak = rev xs (x:ak)

revappend [] ak = ak
revappend (x:xs) ak = revappend xs (x:xs)

odwroc2 xs = revappend xs []

app2 xs ys = revappend (odwroc2 xs) ys


-- Zadanie 2

initsr [] = [[]]
initsr xs = xs:(initsr (init xs))

inits2 xs = reverse $ initsr xs

inits3 [] = [[]]
inits3 xs = inits3 (init xs) ++ [xs]

inits1 xs = [take i xs | i <- [0..length xs]]

inits :: [a] -> [[a]]
inits [] = [[]]
inits (x:xs) = []:[x:ys | ys <- inits xs]


-- Zadanie 3

partitions :: [a] -> [([a], [a])]
partitions [] = [([], [])]
partitions (x:xs) = ([], x:xs):[(x:y1, y2) | (y1, y2) <- partitions xs]


-- Zadanie 4

permutations :: [a] -> [[a]]
permutations [] = [[]]
permutations (x:xs) = [y1 ++ (x:y2) | ys <- permutations xs,
                                      (y1, y2) <- partitions ys]

-- Zadanie 5

nub :: Eq t => [t] -> [t]
nub [] = []
nub (x:xs) = x:zs where
  ys = remove xs x
  zs = nub ys

remove :: Eq a => [a] -> a -> [a]
remove l y = filter (/= y) l
