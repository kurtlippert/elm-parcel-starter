module Topnav exposing (..)

import Button
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (alignRight)
import Element.Input as Input
import Html exposing (Html)
import Model exposing (Model(..))
import Msg exposing (Msg(..))
import String exposing (padRight)


view =
    Element.el
        [ Font.color (Element.rgb 0 0 0)
        , Font.size 18
        , Font.family
            [ Font.typeface "Open Sans"
            , Font.sansSerif
            ]
        ]


topNav : Model -> Html Msg
topNav model =
    layout [ width <| minimum 600 fill, height fill ] <|
        row
            [ Font.color (Element.rgb 0 0 0)
            , Font.size 18
            , Font.family
                [ Font.typeface "Open Sans"
                , Font.sansSerif
                ]
            , width fill
            , centerX
            , Background.color color.gainsboro
            ]
            [ Input.button
                [ alignLeft
                , Element.paddingXY 20 20
                , Font.semiBold
                , focused
                    [ Background.color color.navBackground ]
                ]
                { onPress = Just (ClickedButton "home"), label = text "Elm Parcel Starter" }
            , Button.view [] "Home" "home"
            , Button.view [] "About" "about"
            , Button.view [] "Users" "users"
            , Button.view [ Element.alignRight ] "Log In" "log_in"
            ]


color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF
    , gainsboro = rgb255 0xD4 0xD4 0xD4
    , navBackground = rgb255 0xD4 0xD4 0xD4
    }
