module Page exposing (view)

import Browser exposing (Document)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Lazy exposing (lazy2)
import Element.Region as Region
import Route
import Session exposing (Session)


view : msg -> Session -> { title : String, content : Element msg } -> Document msg
view logoutMsg session { title, content } =
    { title = title ++ " - Elm Launch"
    , body = [ layout [] (view_ logoutMsg session content) ]
    }


view_ : msg -> Session -> Element msg -> Element msg
view_ logoutMsg session content =
    column
        [ width fill
        , height fill
        ]
        [ lazy2 viewHeader logoutMsg session
        , content
        , viewFooter
        ]


viewHeader : msg -> Session -> Element msg
viewHeader logoutMsg session =
    row
        [ Region.navigation
        , width fill
        , height shrink
        , padding 20
        , spacing 20
        ]
        [ siteTitle
        , navLinks logoutMsg session
        ]


siteTitle : Element msg
siteTitle =
    Route.link
        [ Region.heading 1
        , Font.size 24
        , alignLeft
        ]
        (text "Elm Launch")
        Route.Home


navLinks : msg -> Session -> Element msg
navLinks logoutMsg session =
    let
        links =
            if Session.isLoggedIn session then
                [ Input.button
                    [ Font.size 16
                    , Font.color (rgb 0 0 0)
                    , padding 8
                    ]
                    { onPress = Just logoutMsg
                    , label = text "Sign Out"
                    }
                ]

            else
                [ Route.link
                    [ Font.size 16
                    , Font.color (rgb 0 0 0)
                    , padding 8
                    ]
                    (text "Sign In")
                    Route.Login
                , Route.link
                    [ Font.size 16
                    , Font.color (rgb 0 0 0)
                    , padding 8
                    ]
                    (text "Sign Up")
                    Route.Signup
                ]
    in
    row
        [ alignRight
        , spacing 10
        ]
        links


viewFooter : Element msg
viewFooter =
    row
        [ Background.color (rgb255 173 216 230)
        , Region.footer
        , width fill
        , alignBottom
        , padding 20
        , spacing 20
        ]
        [ el
            [ centerX
            , Font.size 12
            ]
            (text "Elm Launch - Copyright Hugo Saracino - Code under BSD-3-Clause Licence")
        ]
