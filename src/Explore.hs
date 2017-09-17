{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoMonomorphismRestriction, FlexibleInstances, TypeSynonymInstances #-}
{-# LANGUAGE DeriveGeneric #-}

module Explore where

import Control.Monad
import Data.Char
import Data.List
import Test.QuickCheck
import Test.QuickCheck.All
import GHC.Generics
import Generic.Random.Generic

-- //
-- quickCheck (\s -> all (`elem` ['a'..'e']) (take5 s))

quickCheckN n = quickCheckWith $ stdArgs { maxSuccess = n }

qsort []     = []
qsort (x:xs) = qsort lhs ++ [x] ++ qsort rhs
  where lhs  = [y | y <- xs, y < x]
        rhs  = [z | z <- xs, z > x]

prop_qsort_isOrdered xs = isOrdered . qsort

prop_qsort_idempotent xs = qsort (qsort xs) == qsort xs

prop_qsort_min xs = head (qsort xs) == minimum xs 

prop_qsort_nn_min xs = not (null xs) ==> head (qsort xs) == minimum xs

prop_qsort_nn_max xs = not (null xs) ==> last (qsort xs) == maximum xs

prop_qsort_sort xs = qsort xs == sort xs -- fails because we throw duplicate elements

isDistinct (x:xs) = not (x `elem` xs) && isDistinct xs
isDistinct _ = True

prop_qsort_distinct = isDistinct . qsort

prop_qsort_distinct_sort xs = (isDistinct xs) ==> qsort xs == sort xs

isOrdered (x1:x2:xs) = x1 <= x2 && isOrdered (x2:xs)
isOrdered _ = True

isort = foldr insert []

prop_insert_ordered'      :: Int -> [Int] -> Bool
prop_insert_ordered' x xs = isOrdered (insert x xs) -- this prop fails because the output is ordered only if the input is

prop_insert_ordered x xs = isOrdered xs ==> isOrdered (insert x xs)

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

-- to have QC work with (ie generate random tests for) values of type a we need only make a an instance of Arbitrary by defining an appropriate arbitrary function for it

prop_sorted_sort :: [Int] -> Property
prop_sorted_sort xs =
  isOrdered xs ==>
  classify (length xs > 1) "non-trivial" $
  sort xs === xs

data MyType = MyType {
    foo :: Int
  , bar :: Bool
  , baz :: Float
  } deriving (Show, Generic)

generateMyType1 = generate $ MyType <$> arbitrary <*> arbitrary <*> arbitrary

-- to avoid repeatedly calling arbitrary , using generic-random
--generateMyType2 = generate (genericArbitrary :: Gen MyType)


return []
main = $quickCheckAll
