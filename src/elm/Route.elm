module Route exposing
    ( Route(..)
    , fromUrl
    , link
    , pushUrl
    )

import Browser.Navigation exposing (Key)
import Element exposing (Attribute, Element)
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s)



-- ROUTING


type Route
    = Home
    | Login
    | Signup


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Login (s "login")
        , Parser.map Signup (s "signup")
        ]



-- PUBLIC NAVIGATION HELPERS


link : List (Attribute msg) -> Element msg -> Route -> Element msg
link attrs label route =
    Element.link attrs
        { label = label
        , url = toString route
        }


pushUrl : Key -> Route -> Cmd msg
pushUrl key route =
    Browser.Navigation.pushUrl key (toString route)


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse parser



-- PRIVATE HELPERS


toString : Route -> String
toString route =
    let
        pieces =
            case route of
                Home ->
                    []

                Login ->
                    [ "login" ]

                Signup ->
                    [ "signup" ]
    in
    "/" ++ String.join "/" pieces
