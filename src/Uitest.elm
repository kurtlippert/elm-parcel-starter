module Uitest exposing (..)

import Browser exposing (Document)
import Browser.Dom exposing (Element)
import Browser.Events exposing (onResize)
import Button
import Element
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (title)
import Msg exposing (Msg(..))
import Platform exposing (Router)
import Topnav exposing (topNav)
import Url.Parser exposing (top)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = \_ -> Msg.NoOp
        , onUrlRequest = \_ -> Msg.NoOp
        }


type alias Model =
    { screenWidth : Int }


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


init : flags -> url -> key -> ( Model, Cmd Msg )
init flags url key =
    ( { screenWidth = 0 }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize (\w h -> Msg.GotNewWidth w)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedButton id ->
            let
                _ =
                    Debug.log "Clicked Button" id
            in
            ( model, Cmd.none )

        GotNewWidth width ->
            ( { model | screenWidth = width }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- topNav : Model -> Html Msg
-- topNav model =
--     -- div [][ text "Howdy Y'all World!" ]
--     navBar


view : Model -> Document Msg
view model =
    { title = "Elm Parcel Starter"
    , body = [ topNav model ]
    }
