
module MonadicQuickCheckPaper where

import Data.List
import Test.QuickCheck
import Test.QuickCheck.All
import Test.QuickCheck.Modifiers

prop_insertOrdered :: Int -> [Int] -> Property
prop_insertOrdered x xs = Ordered xs ==> Ordered (insert x xs)




