module Main exposing (main)

import Auth
import Browser exposing (Document, UrlRequest(..))
import Browser.Events
import Browser.Navigation exposing (Key)
import Element exposing (Device)
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


type alias Model =
    { key : Key
    , session : Session
    , device : Device
    , page : Page
    }


type Page
    = Redirect
    | NotFound
    | Home Home.Model
    | Login Login.Model
    | Signup Signup.Model


{-| Only the user is given at the start of the application.
However, it's conceivable that we'll want to add other parameters
at some point so we might as well put it in a record.
-}
type alias Flags =
    { user : Maybe User
    , windowSize : { width : Int, height : Int }
    }



-- INIT


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init { user, windowSize } url key =
    { key = key
    , session = Session.init user
    , device = Element.classifyDevice windowSize
    , page = Redirect
    }
        |> stepUrl url



-- MSG


type Msg
    = Ignored
    | LinkClicked UrlRequest
    | UrlChanged Url
    | ResizeWindow Int Int
    | GotSession Session
    | HomeMsg Home.Msg
    | LoginMsg Login.Msg
    | SignupMsg Signup.Msg
    | Logout



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Ignored ->
            ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Browser.Navigation.load url
                    )

        UrlChanged url ->
            stepUrl url model

        ResizeWindow width height ->
            ( { model | device = Element.classifyDevice { width = width, height = height } }
            , Cmd.none
            )

        GotSession session ->
            ( { model | session = session }
            , Route.pushUrl model.key Route.Home
            )

        HomeMsg pageMsg ->
            case model.page of
                Home homeModel ->
                    Home.update pageMsg homeModel
                        |> stepPage Home HomeMsg model

                _ ->
                    ( model, Cmd.none )

        LoginMsg pageMsg ->
            case model.page of
                Login loginModel ->
                    Login.update pageMsg loginModel
                        |> stepPage Login LoginMsg model

                _ ->
                    ( model, Cmd.none )

        SignupMsg pageMsg ->
            case model.page of
                Signup signupModel ->
                    Signup.update pageMsg signupModel
                        |> stepPage Signup SignupMsg model

                _ ->
                    ( model, Cmd.none )

        Logout ->
            ( model, Auth.logout () )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        pageSubscriptions =
            case model.page of
                Login pageModel ->
                    Sub.map LoginMsg (Login.subscriptions pageModel)

                Signup pageModel ->
                    Sub.map SignupMsg (Signup.subscriptions pageModel)

                _ ->
                    Sub.none
    in
    Sub.batch
        [ Browser.Events.onResize ResizeWindow
        , Session.changes GotSession
        , pageSubscriptions
        ]



-- VIEW


view : Model -> Document Msg
view model =
    let
        defaultDetails =
            { title = "..."
            , content = Element.none
            , session = model.session
            , logoutMsg = Logout
            }
    in
    case model.page of
        Redirect ->
            Page.view never defaultDetails

        NotFound ->
            Page.view never
                { defaultDetails
                    | title = "404"
                    , content = Element.text "Four, of four!"
                }

        Home pageModel ->
            Page.view HomeMsg
                { defaultDetails
                    | title = "Home"
                    , content = Home.view pageModel
                }

        Login pageModel ->
            Page.view LoginMsg
                { defaultDetails
                    | title = "Login"
                    , content = Login.view pageModel
                }

        Signup pageModel ->
            Page.view SignupMsg
                { defaultDetails
                    | title = "Signup"
                    , content = Signup.view pageModel
                }



-- HELPERS


stepUrl : Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    case Route.fromUrl url of
        Just Route.Home ->
            Home.init
                |> stepPage Home HomeMsg model

        Just Route.Login ->
            Login.init model.key model.session
                |> stepPage Login LoginMsg model

        Just Route.Signup ->
            Signup.init model.key model.session
                |> stepPage Signup SignupMsg model

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


stepPage : (pageModel -> Page) -> (pageMsg -> Msg) -> Model -> ( pageModel, Cmd pageMsg ) -> ( Model, Cmd Msg )
stepPage toModel toMsg model ( pageModel, pageMsg ) =
    ( { model | page = toModel pageModel }
    , Cmd.map toMsg pageMsg
    )
