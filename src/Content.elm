module Content exposing (..)

import Button exposing (button, button3)
import Debug exposing (toString)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (Font)
import Element.Input exposing (focusedOnLoad)
import Html.Attributes exposing (href)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Route exposing (Route(..), fromUrl, routeParser)


type Id
    = String


type RowType
    = First
    | Second
    | Third


type Option
    = OptionOne
    | OptionTwo
    | OptionThree


type RowActions
    = EditRow Id
    | ViewRow Id
    | DeleteRow Id


type alias TestRow =
    { rowNumber : Int
    , id : String
    , name : String
    , rowType : RowType
    , options : List Option
    , floatNumber : Float

    -- , rowActions : RowActions
    }


rowData : List TestRow
rowData =
    [ { rowNumber = 1, id = "first", name = "First", rowType = First, options = [ OptionOne, OptionTwo ], floatNumber = 0.75 }
    , { rowNumber = 2, id = "second", name = "Second", rowType = Second, options = [ OptionThree, OptionTwo ], floatNumber = 3.05 }
    , { rowNumber = 3, id = "third", name = "Third", rowType = Third, options = [ OptionOne ], floatNumber = -0.05 }
    ]


homeContent : Model -> Element Msg
homeContent model =
    let
        headerAttrs =
            [ Font.bold
            , Font.size 14
            , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
            , Border.color color.lightGrey
            ]
    in
    table [ width fill, centerX ]
        { data = rowData
        , columns =
            [ { header = el headerAttrs <| el [ padding 10 ] <| text "#"
              , width = fillPortion 2
              , view = .rowNumber >> toString >> text >> el [ Font.size 14, padding 10 ]
              }
            , { header = el headerAttrs <| el [ padding 10 ] <| text "ID"
              , width = fillPortion 2
              , view = .id >> text >> el [ Font.size 14, padding 10 ]
              }
            , { header = el headerAttrs <| el [ padding 10 ] <| text "Name"
              , width = fillPortion 2
              , view = .name >> text >> el [ Font.size 14, padding 10 ]
              }
            , { header = el headerAttrs <| el [ padding 10 ] <| text "Row Type"
              , width = fillPortion 2
              , view = .rowType >> toString >> text >> el [ Font.size 14, padding 10 ]
              }
            , { header = el headerAttrs <| el [ padding 10 ] <| text "Options"
              , width = fillPortion 2
              , view = .options >> toString >> text >> el [ Font.size 14, padding 10 ]
              }
            , { header = el headerAttrs <| el [ padding 10 ] <| text "Float #"
              , width = fillPortion 2
              , view = .floatNumber >> toString >> text >> el [ Font.size 14, padding 10, Font.alignRight ]
              }
            ]
        }


demoControl : Model -> String -> Element Msg
demoControl model demoRoute =
    case demoRoute of
        "" ->
            homeContent model

        "table" ->
            homeContent model

        "card" ->
            el [ centerX, centerY, padding 50 ] <| text "Card demo"

        "game" ->
            el [ centerX, centerY, padding 50 ] <| text "Game demo"

        _ ->
            el [ centerX, centerY, padding 50 ] <| text "Demo not found"


content : Model -> String -> Element Msg
content model demoRoute =
    row [ width fill, height fill, padding 10, spacing 10 ]
        [ column
            [ width <| px 100
            , height fill
            , Font.size 14
            , paddingXY 10 0
            , Border.widthEach { right = 2, left = 0, top = 0, bottom = 0 }
            , Border.color <| rgb255 0xE0 0xE0 0xE0
            ]
            [ button3
                [ alignTop
                , paddingEach { top = 0, right = 0, bottom = 5, left = 0 }
                ]
                (text "Table")
                (NavigateTo "/demo/table")
            , button3 [ alignTop, paddingXY 0 5 ] (text "Card") (NavigateTo "/demo/card")
            , button3 [ alignTop, paddingXY 0 5 ] (text "Game") (NavigateTo "/demo/game")
            , button3 [ alignBottom, paddingXY 0 5 ] (text "Logout") NoOp
            ]
        , demoControl model demoRoute

        -- , textColumn [ width fill, height fill, spacing 20, scrollbarY, paddingXY 10 0, Font.size 16 ]
        --     [ paragraph [] [ text "Content1" ]
        --     , paragraph [] [ text "Content2" ]
        --     ]
        ]


color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF
    , darkGrey = rgb255 0x67 0x67 0x67
    , navBtnHover = rgb255 0xCE 0xCE 0xCE
    , navBtnClick = rgb255 0xCA 0xCA 0xCA
    , navBackground = rgb255 0xD4 0xD4 0xD4
    , gainsboro = rgb255 0xD4 0xD4 0xD4
    }
