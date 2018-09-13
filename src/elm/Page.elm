module Page exposing (view)

import Browser exposing (Document)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Lazy exposing (lazy2)
import Element.Region as Region
import Palette.Colors exposing (..)
import Palette.Typography as Typo
import Route
import Session exposing (Session)


type alias Details msg a =
    { title : String
    , content : Element a
    , session : Session
    , logoutMsg : msg
    }


view : (a -> msg) -> Details msg a -> Document msg
view toMsg { title, content, session, logoutMsg } =
    { title = title ++ " - Elm Launch"
    , body =
        [ layout [] (view_ toMsg logoutMsg session content) ]
    }


view_ : (a -> msg) -> msg -> Session -> Element a -> Element msg
view_ toMsg logoutMsg session content =
    column
        [ width fill
        , height fill
        ]
        [ lazy2 viewHeader logoutMsg session
        , Element.map toMsg content
        , viewFooter
        ]


viewHeader : msg -> Session -> Element msg
viewHeader logoutMsg session =
    row
        [ Region.navigation
        , Background.color darkgrey
        , Font.color lightgrey
        , Typo.meta
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
        , Typo.xlarge
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
                    [ Typo.medium
                    , padding 8
                    ]
                    { onPress = Just logoutMsg
                    , label = text "Sign Out"
                    }
                ]

            else
                [ Route.link
                    [ Typo.medium
                    , padding 8
                    ]
                    (text "Sign In")
                    Route.Login
                , Route.link
                    [ Typo.medium
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
        [ Border.widthEach { bottom = 0, left = 0, right = 0, top = 1 }
        , Border.color lightgrey
        , Region.footer
        , width fill
        , alignBottom
        , padding 20
        , spacing 20
        ]
        [ el
            [ centerX
            , Typo.small
            , Typo.content
            ]
            (text "Elm Launch - Copyright Hugo Saracino - Code under BSD-3-Clause Licence")
        ]
