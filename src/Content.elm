module Content exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Model exposing (Model)


content : Model -> Element msg
content model =
    row [ width fill, height fill ]
        [ -- [ el [ width <| px model.screenWidth, height <| px 200, Background.color color.lightBlue ] <|
          --     el [ alignRight, width <| px 50, height <| px 150, Background.color color.gainsboro ] <|
          --         text "first"
          el [ width fill, height <| px 200, Background.color color.white ] <|
            el [ alignRight ] <|
                text "main content"
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
