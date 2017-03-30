
-- Ten plik się nie kompiluje! To jest tylko plik poglądowy. 
-- Te wszystkie rzeczy poniĹźej sę w:
import Control.Monad.State

-- specyfikacja protokoĹu MonadState
class Monad m => MonadState s m | m -> s where
  -- odczytuje stan
  get :: m s
  -- zapisuje stan
  put :: s -> m ()

-- uĹźyteczne funkcje pomocnicze
-- odczytaj "fragment" stanu
gets :: MonadState s m => (s -> a) -> m a
gets f = do
  st <- get
  return (f st)

-- zmodyfikuj stan
modify :: MonadState s m => (s -> s) -> m ()
modify f = do
  st <- get
  put (f st)


-- implementacja za pomocÄ konstruktora typu
-- State s izomorficznego z \a. a -> (a,s)
newtype State s a = State{runState :: s -> (a, s)}

instance Monad (State s) where
   -- return :: a -> State s a
   return a = State $ \x -> (a,x)
   -- (>>=) :: State s a -> (a -> State s b) -> State s b
   (State f) >>= g = State $ \x -> let (v,x') = f x in
                             runState (g v) x'

-- funkcje uruchamiajÄce
runState  :: State s a -> s -> (a, s)  -- zdefiniowane powyĹźej
evalState :: State s a -> s -> a
execState :: State s a -> s  ->  s

evalState st = fst . runState st
execState st = snd . runState st


instance MonadState s (State s) where
  get = State $ \x -> (x,x)
  put x =  State $ \_ -> ((),x)

-- i teraz mamy:

get :: State s s
put :: s -> State s ()

gets :: (s -> a) -> State s a
gets f == State $ \x -> (f x, x)

modify :: (s -> s) -> State s ()
modify f == State $ \x -> ((), f x)
