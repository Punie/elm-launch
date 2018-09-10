module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html
import Html.Attributes
import Html.Events


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    Int


type Msg
    = Inc
    | Dec
    | Reset


init =
    0


update msg model =
    case msg of
        Inc ->
            model + 1

        Dec ->
            model - 1

        Reset ->
            init


view model =
    Html.div [ Html.Attributes.class "main" ]
        [ Html.button
            [ Html.Events.onClick Dec ]
            [ Html.text "-" ]
        , Html.span
            []
            [ Html.text <| String.fromInt model ]
        , Html.button
            [ Html.Events.onClick Inc ]
            [ Html.text "+" ]
        , Html.button
            [ Html.Events.onClick Reset ]
            [ Html.text "Reset" ]
        ]
