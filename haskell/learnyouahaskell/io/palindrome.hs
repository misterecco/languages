main = interact respondPalindromes

respondPalindromes :: String -> String
respondPalindromes = unlines . map (\line ->
  if isPalindrome line then "palindrome" else "not a palidrome") . lines
    where isPalindrome line = line == reverse line
