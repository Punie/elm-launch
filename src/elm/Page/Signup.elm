module Page.Signup exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Auth
import Browser.Navigation as Nav exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)
import Palette.Typography as Typo
import Route exposing (Route)
import Session exposing (Session)
import Utils exposing (onEnter)



-- MODEL


type alias Model =
    { error : Maybe Auth.SignupError
    , form : Auth.AuthInfo
    }


init : Key -> Session -> ( Model, Cmd Msg )
init key session =
    let
        model =
            { error = Nothing
            , form = { email = "", password = "" }
            }

        cmd =
            if Session.isLoggedIn session then
                Route.pushUrl key Route.Home

            else
                Cmd.none
    in
    ( model
    , cmd
    )



-- UDPATE


type Msg
    = SubmittedForm
    | EnteredEmail String
    | EnteredPassword String
    | GotError Auth.SignupError


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmittedForm ->
            ( model, Auth.signup model.form )

        EnteredEmail email ->
            updateForm (\form -> { form | email = email }) model

        EnteredPassword password ->
            updateForm (\form -> { form | password = password }) model

        GotError error ->
            ( { model | error = Just error }
            , Cmd.none
            )


updateForm : (Auth.AuthInfo -> Auth.AuthInfo) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Auth.onSignupFailed GotError



-- VIEW


view : Model -> Element Msg
view model =
    column
        [ width (px 400)
        , alignTop
        , centerX
        , Typo.content
        , spacing 12
        , padding 10
        ]
        (viewForm model.form
            ++ [ viewError model.error ]
        )


viewError : Maybe Auth.SignupError -> Element Msg
viewError maybeError =
    paragraph
        [ Font.justify
        , Typo.small
        ]
        [ case maybeError of
            Nothing ->
                none

            Just error ->
                text (Auth.fromSignupError error)
        ]


viewForm : Auth.AuthInfo -> List (Element Msg)
viewForm form =
    [ el
        [ Region.heading 2
        , Typo.large
        , Typo.meta
        , centerX
        ]
        (text "Sign Up")
    , Input.email
        [ spacing 12
        , Typo.medium
        , htmlAttribute (onEnter SubmittedForm)
        ]
        { onChange = EnteredEmail
        , text = form.email
        , placeholder = Nothing
        , label = Input.labelAbove [] (text "Email")
        }
    , Input.currentPassword
        [ spacing 12
        , Typo.medium
        , htmlAttribute (onEnter SubmittedForm)
        ]
        { onChange = EnteredPassword
        , text = form.password
        , placeholder = Nothing
        , label = Input.labelAbove [] (text "Password")
        , show = False
        }
    , Input.button
        [ Border.rounded 5
        , Border.width 1
        , Typo.medium
        , alignRight
        , padding 12
        , width (px 128)
        , height shrink
        ]
        { onPress = Just SubmittedForm
        , label = text "Sign Up"
        }
    ]
