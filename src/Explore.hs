{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoMonomorphismRestriction, FlexibleInstances, TypeSynonymInstances #-}

module Explore where

import Control.Monad
import Data.Char
import Data.List
import Test.QuickCheck
import Test.QuickCheck.All

isOrdered (x1:x2:xs) = x1 <= x2 && isOrdered (x2:xs)
isOrdered _ = True

prop_insert_ordered_vacuous x xs =
  collect (length xs) $
  classify (isOrdered xs) "ord" $
  classify (not (isOrdered xs)) "not-ord" $
  not (isOrdered xs) || isOrdered (insert x xs)


--
genList2 :: (Arbitrary a) => Gen [a]
genList2 = oneof [ (return [])
                 , (liftM2 (:) arbitrary genList2)]

genList3 :: (Arbitrary a) => Gen [a]
genList3 = frequency [(1, return []), (7, liftM2 (:) arbitrary genList2)]

genOrdList = genList3 >>= return . sort

prop_insert :: Int -> Property
prop_insert x = forAll genOrdList $ \xs -> isOrdered xs && isOrdered (insert x xs)

-- //
-- quickCheck (\s -> all (`elem` ['a'..'e']) (take5 s))

quickCheckN n = quickCheckWith $ stdArgs { maxSuccess = n }

qsort []     = []
qsort (x:xs) = qsort lhs ++ [x] ++ qsort rhs
  where lhs  = [y | y <- xs, y < x]
        rhs  = [z | z <- xs, z > x]

prop_qsort_isOrdered xs = isOrdered . qsort

prop_qsort_idempotent xs = qsort (qsort xs) == qsort xs


return []
main = $quickCheckAll
