module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Undefinable (toUndefinable, toMaybe)
import Effect (Effect)
import Test.Assert (assertEqual)

main :: Effect Unit
main = do
  assertEqual
    { actual: show $ toUndefinable (Nothing :: Maybe Number)
    , expected: "undefined"
    }
  assertEqual
    { actual: show $ toUndefinable (Just 42)
    , expected: "42"
    }
  assertEqual
    { actual: toMaybe $ toUndefinable (Nothing :: Maybe Number)
    , expected: Nothing
    }
  assertEqual
    { actual: toMaybe $ toUndefinable (Just 42)
    , expected: Just 42
    }
  assertEqual
    { actual: toUndefinable Nothing == toUndefinable (Just 42)
    , expected: false
    }
  assertEqual
    { actual: toUndefinable Nothing `compare` toUndefinable (Just 42)
    , expected: LT
    }
