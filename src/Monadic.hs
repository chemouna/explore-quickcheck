
module Monadic where

import System.Process
import Test.QuickCheck
import Test.QuickCheck.Monadic

-- $ factor 16
-- 16: 2 2 2 2
factor :: Integer -> IO [Integer]
factor n = parse `fmap` readProcess "factor" [show n] "" where

  parse :: String -> [Integer]
  parse = map read . tail . words

prop_factor :: Positive Integer -> Property
prop_factor (Positive n) = monadicIO $ do
  factors <- run (factor n)

  assert (product factors == n)


