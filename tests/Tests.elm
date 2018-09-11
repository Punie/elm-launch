module Tests exposing (suite)

import Expect exposing (equal)
import Fuzz exposing (int)
import Test exposing (Test, describe, fuzz, test)


suite : Test
suite =
    describe "Test Suite"
        [ test "Success" <|
            \_ ->
                identity 0
                    |> equal 0
        ]
