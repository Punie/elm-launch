module Page.Signup exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , toSession
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
import Route exposing (Route)
import Session exposing (Session)
import Utils exposing (onEnter)


type alias Model =
    { error : Maybe Auth.SignupError
    , form : Auth.AuthInfo
    , session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    let
        model =
            { error = Nothing
            , form = { email = "", password = "" }
            , session = session
            }

        cmd =
            if Session.isLoggedIn session then
                Route.pushUrl (Session.navKey session) Route.Home

            else
                Cmd.none
    in
    ( model
    , cmd
    )


type Msg
    = SubmittedForm
    | EnteredEmail String
    | EnteredPassword String
    | GotSession Session
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

        GotSession session ->
            ( { model | session = session }
            , Route.pushUrl (Session.navKey session) Route.Home
            )

        GotError error ->
            ( { model | error = Just error }
            , Cmd.none
            )


updateForm : (Auth.AuthInfo -> Auth.AuthInfo) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        key =
            Session.navKey model.session
    in
    Sub.batch
        [ Session.changes GotSession key
        , Auth.onSignupFailed GotError
        ]


view : Model -> Element Msg
view model =
    column
        [ width (px 400)
        , alignTop
        , centerX
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
        , Font.size 12
        ]
        [ case maybeError of
            Nothing ->
                none

            Just error ->
                case error of
                    Auth.EmailAlreadyInUse message ->
                        text message

                    Auth.OperationNotAllowed message ->
                        text message

                    Auth.WeakPassword message ->
                        text message

                    Auth.SignupError (Auth.InvalidEmail message) ->
                        text message

                    Auth.SignupError (Auth.Other _ message) ->
                        text message
        ]


viewForm : Auth.AuthInfo -> List (Element Msg)
viewForm form =
    [ el
        [ Region.heading 2
        , Font.size 24
        , centerX
        ]
        (text "Sign Up")
    , Input.email
        [ spacing 12
        , Font.size 16
        , htmlAttribute (onEnter SubmittedForm)
        ]
        { onChange = EnteredEmail
        , text = form.email
        , placeholder = Nothing
        , label = Input.labelAbove [] (text "Email")
        }
    , Input.currentPassword
        [ spacing 12
        , Font.size 16
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
        , Font.size 20
        , alignRight
        , padding 12
        , width (px 128)
        , height shrink
        ]
        { onPress = Just SubmittedForm
        , label = text "Sign Up"
        }
    ]


toSession : Model -> Session
toSession =
    .session
