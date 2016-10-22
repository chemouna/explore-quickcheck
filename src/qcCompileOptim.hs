module QcCompileOptim where

import           Control.Monad
import           Control.Monad.Trans.State.Lazy
import           Data.List
import qualified Data.Map as M
import           Test.QuickCheck
import           Test.QuickCheck.All

data Expression =
      Var   Variable
    | Val   Value
    | Plus  Expression Expression
    | Minus Expression Expression
    deriving (Eq, Ord)

data Variable = V String deriving (Eq, Ord)

data Value =
      IntVal Int
    | BoolVal Bool
    deriving (Eq, Ord)

data Statement =
      Assign Variable Expression
    | If Expression Statement Statement
    | While Expression Statement
    | Sequence Statement Statement
    | Skip
    deriving (Eq, Ord)

type WState = M.Map Variable Value

execute ::  WState -> Statement -> WState
execute env = flip execState env . evalS

evalE :: Expression -> State WState Value
evalE (Var x)       = get >>= return . M.findWithDefault (IntVal 0) x
evalE (Val v)       = return v
evalE (Plus e1 e2)  = return (intOp (+) 0 IntVal) `ap` evalE e1 `ap` evalE e2
evalE (Minus e1 e2) = return (intOp (-) 0 IntVal) `ap` evalE e1 `ap` evalE e2

evalS :: Statement -> State WState ()
evalS w@(While e s)    = evalS (If e (Sequence s w) Skip)
evalS Skip             = return ()
evalS (Sequence s1 s2) = evalS s1 >> evalS s2
evalS (Assign x e )    = do v <- evalE e
                            m <- get
                            put $ M.insert x v m
                            return ()
evalS (If e s1 s2)     = do v <- evalE e
                            case v of
                              BoolVal True  -> evalS s1
                              BoolVal False -> evalS s2
                              _             -> return ()

intOp :: (Int -> Int -> a) -> a -> (a -> Value) -> Value -> Value -> Value
intOp op _ c (IntVal x) (IntVal y) = c $ x `op` y
intOp _  d c _          _          = c d


-- generator for variables
instance Arbitrary Variable where
  arbitrary = do x <- elements ['A'..'Z']
                 return $ V [x]

-- generator for values
instance Arbitrary Value where
  arbitrary = oneof [ liftM IntVal arbitrary, liftM BoolVal arbitrary]

-- generator for expressions
instance Arbitrary Expression where
  arbitrary = frequency [(1, liftM Var arbitrary),
                         (1, liftM Val arbitrary),
                         (5, liftM2 Plus arbitrary arbitrary),
                         (5, liftM2 Minus arbitrary arbitrary)]

-- generator for WState so we can run while for arbitrary input config

instance (Ord a, Arbitrary a, Arbitrary b) => Arbitrary (M.Map a b) where
  arbitrary = do xvs <- arbitrary
                 return $ M.fromList xvs
