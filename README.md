# Undefinable

[![CI](https://github.com/ethul/purescript-undefinable/workflows/CI/badge.svg?branch=main)](https://github.com/ethul/purescript-undefinable/actions?query=workflow%3ACI+branch%3Amain)
[![Release](https://img.shields.io/github/release/ethul/purescript-undefinable.svg)](https://github.com/ethul/purescript-undefinable/releases)
[![Pursuit](https://pursuit.purescript.org/packages/purescript-undefinable/badge)](https://pursuit.purescript.org/packages/purescript-undefinable)

A library for dealing with undefined values in foreign libraries.

`undefinable` is intended to be used with PureScript's [Foreign Function Interface (FFI)](https://github.com/purescript/documentation/blob/master/guides/FFI.md). If you are looking for general-purpose optional values, use [`Maybe`](https://github.com/purescript/purescript-maybe) instead.

## Installation

Install `undefinable` with [Spago](https://github.com/purescript/spago):

```sh
spago install undefinable
```

## Quick start

> The following example lives in [`examples`](./examples) and can be built and run using `spago -x examples.dhall run`.

Here we have a little JavaScript function that we can use to determine whether a number is unlucky. We give it some number and it will either return `undefined` if the number is considered "unlucky" or just return the number otherwise:

```js
export function unluckyImpl(n) {
  // Unlucky number 13!
  if (n === 13) {
    return undefined; // but not null
  }

  return n;
}
```

If we want to use this function from PureScript we'll need to go through the FFI:

```purescript
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
```

You can run the following to load this example up in the REPL:

```
cd examples && spago repl
```

Once the REPL is loaded, go ahead and add the following imports:

```purescript
import Prelude
import Data.Maybe
import QuickStart
```

You can now test out our `unlucky` function in the REPL:

```purescript
unlucky 7  == Just 7
unlucky 13 == Nothing
```

## Documentation

`undefinable` documentation is stored in a few places:

1. Module documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-undefinable).
2. Written documentation is kept in the [docs directory](./docs).
3. Usage examples can be found in [the test suite](./test).

If you get stuck, there are several ways to get help:

- [Open an issue](https://github.com/ethul/purescript-undefinable/issues) if you have encountered a bug or problem.
- Ask general questions on the [PureScript Discourse](https://discourse.purescript.org) forum or the [PureScript Discord](https://purescript.org/chat) chat.

## Contributing

You can contribute to `undefinable` in several ways:

1. If you encounter a problem or have a question, please [open an issue](https://github.com/ethul/purescript-undefinable/issues). We'll do our best to work with you to resolve or answer it.

2. If you would like to contribute code, tests, or documentation, please [read the contributor guide](./CONTRIBUTING.md). It's a short, helpful introduction to contributing to this library, including development instructions.

3. If you have written a library, tutorial, guide, or other resource based on this package, please share it on the [PureScript Discourse](https://discourse.purescript.org)! Writing libraries and learning resources are a great way to help this library succeed.
