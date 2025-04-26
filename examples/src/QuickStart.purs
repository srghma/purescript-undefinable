module QuickStart
  ( unlucky -- We only want to expose our "safe" `unlucky` function outside of
  -- this module and keep the backing implementation (`unluckyImpl`)
  -- hidden.
  ) where

import Prelude
import Data.Function.Uncurried (Fn1, runFn1)
import Data.Maybe (Maybe)
import Data.Undefinable (Undefinable, toMaybe)

-- Here we declare a binding to a foreign JavaScript function that we'll call
-- out to using the FFI.
--
-- This function takes an `Int` and then returns either an integer or a `undefined`
-- based on the given value. We use `Undefinable Int` to indicate that we could
-- get a `undefined` back from this function.
foreign import unluckyImpl :: Fn1 Int (Undefinable Int)

-- We don't want to have to use `Undefinable` in our PureScript code, so we can use
-- `toMaybe` to convert our `Undefinable Int` into a `Maybe Int` which will then be
-- part of the API visible outside of this module.
unlucky :: Int -> Maybe Int
unlucky n = toMaybe $ runFn1 unluckyImpl n
