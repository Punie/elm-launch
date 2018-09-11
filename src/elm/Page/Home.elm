module Page.Home exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , toSession
    , update
    , view
    )

import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import Html.Attributes
import Http
import Markdown
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    , content : String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    let
        initModel =
            { session = session
            , content = ""
            }

        initCmd =
            Http.getString "/static/assets/welcome.md"
                |> Http.send GotContent
    in
    ( initModel, initCmd )



-- UPDATE


type Msg
    = GotContent (Result Http.Error String)
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotContent (Ok content) ->
            ( { model | content = content }, Cmd.none )

        GotContent (Err _) ->
            ( { model | content = "Could not load content" }, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- VIEW


view : Model -> Element Msg
view model =
    paragraph
        [ width (px 800)
        , spacing 10
        , padding 20
        , centerX
        , Font.size 14
        , Font.justify
        , Region.mainContent
        ]
        [ html <|
            Markdown.toHtml
                [ Html.Attributes.class "markdown-content" ]
                model.content
        ]



-- EXPORT


toSession : Model -> Session
toSession =
    .session
