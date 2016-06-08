{-# LANGUAGE TemplateHaskell #-}

module Examples.Test where

import Test.QuickCheck
import Test.QuickCheck.All
import Test.QuickCheck.Modifiers

-- Expl 1


-- TODO: some quickcheck examples todo :
-- http://brandon.si/code/writing-a-streaming-twitter-waterflow-solution/
-- http://cseweb.ucsd.edu/classes/wi15/cse230-a/lectures/lec-quickcheck.html
-- http://www.haskellforall.com/2013/11/test-stream-programming-using-haskells.html


-- robin :: Int -> [RobinRound]
-- robin n = map (filter notDummy . toPairs) rounds where
--   n' = if odd n then n+1 else n
--   m = n' `div` 2 -- matches per round
--   rounds = take (n'-1) $ iterate robinPermute [1..n']
--   notDummy (x,y) = all (<=n) [x,y]
--   toPairs x =  take m $ zip x (reverse x)

-- robinPermute :: [Int] -> [Int]
-- robinPermute [] = []
-- robinPermute (x:xs) = x : last xs : init xs

-- type RobinRound = [(Int, Int)]

-- verify correct number of rounds
-- robinProp1 :: Int -> Bool
-- robinProp1 n = 
--   let rs = T.robin n in length rs == (if odd n then n else n-1)

-- main = do
--   quickCheck robinProp1

return []
main = $quickCheckAll



