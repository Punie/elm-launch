module Tests exposing (suite)

import Expect exposing (equal)
import Fuzz exposing (int)
import Main exposing (Msg(..), update)
import Test exposing (Test, describe, fuzz, test)


suite : Test
suite =
    describe "Update"
        [ fuzz int "Increment" <|
            \n ->
                update Inc n
                    |> equal (n + 1)
        , fuzz int "Decrement" <|
            \n ->
                update Dec n
                    |> equal (n - 1)
        , fuzz int "Reset" <|
            \n ->
                update Reset n
                    |> equal 0
        ]
