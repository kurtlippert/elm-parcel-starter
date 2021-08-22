module Button exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Msg exposing (Msg(..))


view : List (Attribute Msg) -> String -> String -> Element Msg
view moreAttributes buttonText id =
    Input.button
        (List.concat
            [ moreAttributes
            , [ paddingXY 10 20

              -- The order of mouseDown/mouseOver can be significant when changing
              -- the same attribute in both
              , mouseDown
                    [ Background.color color.navBtnClick
                    , Border.color color.navBtnClick
                    , Font.color color.darkCharcoal
                    ]
              , mouseOver
                    [ Background.color color.navBtnHover
                    , Border.color color.navBtnHover
                    ]
              , focused
                    [ Background.color color.navBtnHover
                    ]
              ]
            ]
        )
        { onPress = Just (ClickedButton id), label = text buttonText }


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
    }
