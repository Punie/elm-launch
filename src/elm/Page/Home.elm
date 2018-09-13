module Page.Home exposing
    ( Model
    , Msg
    , init
    , update
    , view
    )

import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import Html.Attributes
import Http
import Markdown
import Palette.Typography as Typo
import Session exposing (Session)



-- MODEL


type alias Model =
    { content : String
    }


init : ( Model, Cmd Msg )
init =
    let
        initModel =
            { content = ""
            }

        initCmd =
            Http.getString "/static/assets/welcome.md"
                |> Http.send GotContent
    in
    ( initModel, initCmd )



-- UPDATE


type Msg
    = GotContent (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotContent (Ok content) ->
            ( { model | content = content }, Cmd.none )

        GotContent (Err _) ->
            ( { model | content = "Could not load content" }, Cmd.none )



-- VIEW


view : Model -> Element Msg
view model =
    paragraph
        [ width (px 800)
        , spacing 10
        , padding 20
        , centerX
        , Typo.content
        , Typo.medium
        , Font.justify
        , Region.mainContent
        ]
        [ html <|
            Markdown.toHtml
                [ Html.Attributes.class "markdown-content" ]
                model.content
        ]
