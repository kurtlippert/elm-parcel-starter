module Button exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Msg exposing (Msg(..))


button : List (Attribute Msg) -> String -> Msg -> Element Msg
button moreAttributes buttonText msg =
    Input.button
        (List.concat
            [ moreAttributes
            , [ -- The order of mouseDown/mouseOver can be significant when changing
                -- the same attribute in both
                mouseDown
                    [ Background.color color.navBtnHover
                    , Border.color color.navBtnHover
                    , Font.color color.navTextHover
                    ]
              , mouseOver
                    [ Background.color color.navBtnHover
                    , Border.color color.navBtnHover
                    , Font.color color.navTextHover
                    ]
              , focused
                    [ Background.color color.navBtnHover
                    , Font.color color.navTextHover
                    ]
              ]
            ]
        )
        { onPress = Just msg, label = text buttonText }


color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF
    , darkGrey = rgb255 0x67 0x67 0x67
    , navBtnHover = rgb255 0xFA 0xFA 0xFA
    , navTextHover = rgb255 0x48 0x5F 0xC7
    , navBtnClick = rgb255 0xCA 0xCA 0xCA
    , navBackground = rgb255 0xD4 0xD4 0xD4
    }
