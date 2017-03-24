module L where

-- instance Monad [] where
--   return x = [x]
--   xs >>= f = concat (map f xs)
--   fail _ = []


class Monad m => MonadPlus m where
    mzero :: m a
    mplus :: m a -> m a -> m a

instance MonadPlus [] where
    mzero = []
    mplus = (++)


guard :: (MonadPlus m) => Bool -> m ()
guard True = return ()
guard False = mzero
