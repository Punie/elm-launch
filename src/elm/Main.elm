module Main exposing (main)

import Auth
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation exposing (Key)
import Element
import Page
import Page.Home as Home
import Page.Login as Login
import Page.Signup as Signup
import Route
import Session exposing (Session)
import Url exposing (Url)
import User exposing (User)



-- MAIN


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



-- MODEL


type Model
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | Login Login.Model
    | Signup Signup.Model


{-| Only the user is given at the start of the application.
However, it's conceivable that we'll want to add other parameters
at some point so we might as well put it in a record.
-}
type alias Flags =
    { user : Maybe User }



-- INIT


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init { user } url key =
    Redirect (Session.init key user)
        |> stepUrl url



-- MSG


type Msg
    = Ignored
    | LinkClicked UrlRequest
    | UrlChanged Url
    | HomeMsg Home.Msg
    | LoginMsg Login.Msg
    | SignupMsg Signup.Msg
    | Logout



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        session =
            toSession model
    in
    case msg of
        Ignored ->
            ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl (Session.navKey session) (Url.toString url)
                    )

                External url ->
                    ( model
                    , Browser.Navigation.load url
                    )

        UrlChanged url ->
            stepUrl url model

        HomeMsg pageMsg ->
            case model of
                Home pageModel ->
                    Home.update pageMsg pageModel
                        |> stepPage Home HomeMsg model

                _ ->
                    ( model, Cmd.none )

        LoginMsg pageMsg ->
            case model of
                Login pageModel ->
                    Login.update pageMsg pageModel
                        |> stepPage Login LoginMsg model

                _ ->
                    ( model, Cmd.none )

        SignupMsg pageMsg ->
            case model of
                Signup pageModel ->
                    Signup.update pageMsg pageModel
                        |> stepPage Signup SignupMsg model

                _ ->
                    ( model, Cmd.none )

        Logout ->
            ( model, Auth.logout () )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Home pageModel ->
            Sub.map HomeMsg (Home.subscriptions pageModel)

        Login pageModel ->
            Sub.map LoginMsg (Login.subscriptions pageModel)

        Signup pageModel ->
            Sub.map SignupMsg (Signup.subscriptions pageModel)

        _ ->
            Sub.none



-- VIEW


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

        Home pageModel ->
            Page.view
                Logout
                session
                { title = "Home"
                , content = Element.map HomeMsg <| Home.view pageModel
                }

        Login pageModel ->
            Page.view
                Logout
                session
                { title = "Login"
                , content = Element.map LoginMsg <| Login.view pageModel
                }

        Signup pageModel ->
            Page.view
                Logout
                session
                { title = "Signup"
                , content = Element.map SignupMsg <| Signup.view pageModel
                }



-- HELPERS


stepUrl : Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        session =
            toSession model
    in
    case Route.fromUrl url of
        Just Route.Home ->
            Home.init session
                |> stepPage Home HomeMsg model

        Just Route.Login ->
            Login.init session
                |> stepPage Login LoginMsg model

        Just Route.Signup ->
            Signup.init session
                |> stepPage Signup SignupMsg model

        Nothing ->
            ( NotFound session, Cmd.none )


stepPage : (pageModel -> Model) -> (pageMsg -> Msg) -> Model -> ( pageModel, Cmd pageMsg ) -> ( Model, Cmd Msg )
stepPage toModel toMsg _ ( pageModel, pageMsg ) =
    ( toModel pageModel
    , Cmd.map toMsg pageMsg
    )


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
