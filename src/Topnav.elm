module Topnav exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Events exposing (Visibility)
import Button exposing (button)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (shadow)
import Element.Font as Font
import Element.Input as Input
import Model exposing (Model)
import Msg exposing (Msg(..))
import Route exposing (Route)


thing : List (Element.Attribute msg)
thing =
    [ Font.color (Element.rgb 0 0 0)
    , Font.size 18
    , Font.family
        [ Font.typeface "Open Sans"
        , Font.sansSerif
        ]
    , width fill
    , centerX
    , Background.color color.white
    , shadow { offset = ( 0, 10 ), size = -1, blur = 15, color = color.dropShadow }
    ]



-- topNav : Model -> Element.Attribute Msg -> Element Msg


topNav : Model -> Element Msg
topNav model =
    row
        [ Font.color (Element.rgb 0 0 0)
        , Font.size 18
        , Font.family
            [ Font.typeface "Open Sans"
            , Font.sansSerif
            ]
        , width fill
        , centerX
        , Background.color color.white
        , shadow { offset = ( 0, 10 ), size = -1, blur = 15, color = color.dropShadow }

        -- , layeredAttributeMsg
        ]
        [ Input.button
            [ alignLeft
            , Element.paddingXY 20 20
            , Font.semiBold
            , focused
                [ Background.color color.white ]
            ]
            { onPress = Just (NavigateTo "/"), label = text "Elm Parcel Starter" }
        , button [ paddingXY 10 20 ] "Home" (NavigateTo "/")
        , button [ paddingXY 10 20 ] "About" (NavigateTo "/about")
        , button [ paddingXY 10 20 ] "Users" (NavigateTo "/users")
        , el
            [ Element.below <|
                el
                    [ alignLeft
                    , width <| px 150
                    , paddingXY 0 10
                    , Background.color color.white
                    , moveLeft 80
                    , shadow { offset = ( 0, 10 ), size = -1, blur = 15, color = color.dropShadow }
                    , Element.Border.widthEach { top = 2, right = 0, bottom = 0, left = 0 }
                    , Element.Border.solid
                    , Element.Border.color <| rgb255 0xDF 0xDF 0xDF
                    , transparent <| not model.loginActive
                    ]
                <|
                    column [ width fill ]
                        [ button [ Font.size 16, paddingXY 10 10, width fill ] "First Element" NoOp
                        , button [ Font.size 16, paddingXY 10 10, width fill ] "Second Element" NoOp
                        , button [ Font.size 16, paddingXY 10 10, width fill ] "Third Element" NoOp
                        ]
            , alignRight
            ]
            (button [ alignRight, paddingXY 10 20 ] "Log In" ShowLogin)
        ]


topNavDropdownRow : Model -> Element Msg
topNavDropdownRow model =
    el
        [ width <| px 300
        , height <| px 150

        -- , centerX
        , alignRight
        , Background.color <| color.blue
        ]
    <|
        el [ centerX, centerY ] <|
            text "Left"



-- [ el
--     [ centerX
--     , centerY
--     , width
--     , height
--     -- , Background.color color.blue
--     ]
--   <|
--     text "Left"
-- , el
--     [ moveUp 25
--     , width <| px 50
--     , height <| px 50
--     , centerX
--     , Background.color color.blue
--     ]
--   <|
--     text "Up"
-- , el
--     [ moveDown 25
--     , width <| px 50
--     , height <| px 50
--     , centerX
--     , Background.color color.blue
--     ]
--   <|
--     text "Down"
-- , el
--     [ moveRight 25
--     , width <| px 50
--     , height <| px 50
--     , alignRight
--     , Background.color color.blue
--     ]
--   <|
--     text "Right"


color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF
    , gainsboro = rgb255 0xD4 0xD4 0xD4
    , navBackground = rgb255 0xD4 0xD4 0xD4
    , navHover = rgb255 0xFA 0xFA 0xFA
    , navTextHover = rgb255 0x48 0x5F 0xC7
    , dropShadow = rgba 0.04 0.04 0.04 0.1
    }
