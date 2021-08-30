module Footer exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Svg.Attributes as SvgAttr
import SvgIcons.Smirk exposing (smirk)


logo : Element msg
logo =
    el
        [ width <| px 80
        , height <| px 40
        , Border.width 2
        , Border.rounded 6
        , Border.color color.blue
        ]
        none


footer : Element msg
footer =
    el
        [ width fill
        , padding 25
        , Background.color color.lightGrey
        , Font.size 14
        ]
    <|
        row
            [ centerX, centerY ]
            [ el [] <| text "footer made in elm-ui"
            , el [ paddingEach { top = 0, right = 0, bottom = 0, left = 5 } ] <|
                smirk [ SvgAttr.width "14", SvgAttr.height "14" ]
            ]


color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xFA 0xFA 0xFA
    , white = rgb255 0xFF 0xFF 0xFF
    , darkGrey = rgb255 0x67 0x67 0x67
    , navBtnHover = rgb255 0xCE 0xCE 0xCE
    , navBtnClick = rgb255 0xCA 0xCA 0xCA
    , navBackground = rgb255 0xD4 0xD4 0xD4
    , gainsboro = rgb255 0xD4 0xD4 0xD4
    }
