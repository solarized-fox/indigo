module Main exposing (..)

import App.Model exposing (..)
import App.Msg exposing (..)
import App.PageRouting as PageRouting
import App.SubMenu as SubMenu
import Browser exposing (..)
import Browser.Navigation as Nav
import Element exposing (..)
import Html exposing (..)
import Html.Attributes exposing (href)
import Modules.BumpToNormal as BumpToNormal
import Url exposing (Url)


type alias Flags =
    {}


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = UrlChange
        }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ _ navKey =
    ( Model Bump2Normal navKey BumpToNormal.initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange url ->
            PageRouting.urlUpdate url model

        ClickedLink (Browser.Internal url) ->
            ( model, Nav.pushUrl model.navKey <| Url.toString url )

        ClickedLink (Browser.External href) ->
            ( model, Nav.load href )

        BumpToNormalMsgWrapper b2nMsg ->
            case BumpToNormal.update b2nMsg model.bumpToNormal of
                ( m, cmd ) ->
                    ( { model | bumpToNormal = m }, Cmd.map (\e -> BumpToNormalMsgWrapper e) cmd )


view : Model -> Document Msg
view model =
    { title = "Indigo Tools"
    , body =
        [ div []
            [ SubMenu.view
            , Element.layout [] (PageRouting.pageContent model)
            ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
