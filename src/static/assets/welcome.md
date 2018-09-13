# Elm Launch 🚀

Welcome to **Elm Launch**!

⚠️ This is an early demo. At the moment you can only try to [Sign In](/login) or [Sign Up](/signup) and see what happens.

### Features

This project showcases how to use elm for a Single Page Application in association with:

-   firebase
-   highlight.js
-   typescript
-   webpack

The moto here is as such:

> Trying as much as possible to make impossible states impossible!

### Code example

```elm
module Maybe exposing
    ( Maybe(..)
    , map
    )


type Maybe a
    = Just a
    | Nothing


map : (a -> b) -> Maybe a -> Maybe b
map f maybe =
    case maybe of
        Just a ->
            Just (f a)

        Nothing ->
            Nothing
```
