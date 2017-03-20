import Control.Monad

main :: IO [()]
main = do
  colors <- forM [1,2,3,4] (\a -> do
    putStrLn $ "Which color do you associate with the number " ++ show a ++ "?"
    getLine)
  putStrLn "The colors the you associate with 1,2,3,4 are: "
  mapM putStrLn colors
