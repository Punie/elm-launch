module Main exposing (main)

import Auth
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation exposing (Key)
import Element
import Page
import Page.Home as Home
import Page.Login as Login
import Page.Signup as Signup
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)
import User exposing (User)


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Flags =
    { user : Maybe User }


type Model
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | Login Login.Model
    | Signup Signup.Model


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init { user } url key =
    stepUrl url <|
        Redirect (Session.init key user)


stepUrl : Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        session =
            toSession model
    in
    case Route.fromUrl url of
        Just Route.Home ->
            stepHome (Home.init session)

        Just Route.Login ->
            stepLogin (Login.init session)

        Just Route.Signup ->
            stepSignup (Signup.init session)

        Nothing ->
            ( NotFound session, Cmd.none )


stepHome : ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
stepHome ( model, msg ) =
    ( Home model
    , Cmd.map HomeMsg msg
    )


stepLogin : ( Login.Model, Cmd Login.Msg ) -> ( Model, Cmd Msg )
stepLogin ( model, msg ) =
    ( Login model
    , Cmd.map LoginMsg msg
    )


stepSignup : ( Signup.Model, Cmd Signup.Msg ) -> ( Model, Cmd Msg )
stepSignup ( model, msg ) =
    ( Signup model
    , Cmd.map SignupMsg msg
    )



-- changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
-- changeRouteTo maybeRoute model =
--     let
--         session =
--             toSession model
--     in
--     case maybeRoute of
--         Just Route.Home ->
--             let
--                 ( homeModel, homeCmd ) =
--                     Home.init session
--             in
--             ( Home homeModel
--             , Cmd.map HomeMsg homeCmd
--             )
--         _ ->
--             ( NotFound session, Cmd.none )


type Msg
    = Ignored
    | LinkClicked UrlRequest
    | UrlChanged Url
    | HomeMsg Home.Msg
    | LoginMsg Login.Msg
    | SignupMsg Signup.Msg
    | Logout


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Ignored ->
            ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                    )

                External url ->
                    ( model
                    , Browser.Navigation.load url
                    )

        UrlChanged url ->
            stepUrl url model

        HomeMsg subMsg ->
            case model of
                Home home ->
                    stepHome (Home.update subMsg home)

                _ ->
                    ( model, Cmd.none )

        LoginMsg subMsg ->
            case model of
                Login login ->
                    stepLogin (Login.update subMsg login)

                _ ->
                    ( model, Cmd.none )

        SignupMsg subMsg ->
            case model of
                Signup signup ->
                    stepSignup (Signup.update subMsg signup)

                _ ->
                    ( model, Cmd.none )

        Logout ->
            ( model, Auth.logout () )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Home home ->
            Sub.map HomeMsg (Home.subscriptions home)

        Login login ->
            Sub.map LoginMsg (Login.subscriptions login)

        Signup signup ->
            Sub.map SignupMsg (Signup.subscriptions signup)

        _ ->
            Sub.none


view : Model -> Document Msg
view model =
    let
        session =
            toSession model
    in
    case model of
        Redirect _ ->
            Page.view
                Logout
                session
                { title = "..."
                , content = Element.none
                }

        NotFound _ ->
            Page.view
                Logout
                session
                { title = "404"
                , content = Element.text "Four, oh four!"
                }

        Home home ->
            Page.view
                Logout
                session
                { title = "Home"
                , content = Element.map HomeMsg <| Home.view home
                }

        Login login ->
            Page.view
                Logout
                session
                { title = "Login"
                , content = Element.map LoginMsg <| Login.view login
                }

        Signup signup ->
            Page.view
                Logout
                session
                { title = "Signup"
                , content = Element.map SignupMsg <| Signup.view signup
                }


toSession : Model -> Session
toSession model =
    case model of
        Redirect session ->
            session

        NotFound session ->
            session

        Home home ->
            Home.toSession home

        Login login ->
            Login.toSession login

        Signup signup ->
            Signup.toSession signup
