module E where

import Control.Monad

-- instance (Error e) => Monad (Either e) where
--   return x = Right x
--   Right x >>= f = f x
--   Left err >>= f = Left err
--   fail msg = Left (strMsg msg)
