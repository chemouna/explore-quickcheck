{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}

module ConditionalProperties where

import Test.QuickCheck
import Test.QuickCheck.All
import Test.QuickCheck.Modifiers
import Data.List


merge :: Ord a => [a] -> [a] -> [a]
merge xs     []     = xs
merge []     ys     = ys
merge (x:xs) (y:ys)
  | x <= y          = x : merge xs (y:ys)
  | otherwise       = y : merge (x:xs) ys

ordered :: Ord a => [a] -> Bool
ordered []       = True
ordered [x]      = True
ordered (x:y:xs) = x <= y && ordered (y:xs)

prop_merge :: [Int] -> [Int] -> Property
prop_merge xs ys = (ordered xs && ordered ys) ==> ordered (merge xs ys)

prop_merge2 (Ordered xs) (Ordered (ys :: [Int])) = ordered (xs `merge` ys)

return []
main = $quickCheckAll
