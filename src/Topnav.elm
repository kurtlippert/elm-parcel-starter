module Topnav exposing (..)

import Browser exposing (UrlRequest(..))
import Button exposing (button)
import Element exposing (..)
import Element.Background as Background
import Element.Border exposing (shadow)
import Element.Events exposing (onClick, onLoseFocus, onMouseEnter, onMouseLeave)
import Element.Font as Font
import Element.Input as Input
import Model exposing (Model)
import Msg exposing (Msg(..))
import Svg.Attributes as SvgAttr
import SvgIcons.CurvedDown exposing (curvedDown)


topNav : Model -> Element Msg
topNav model =
    row
        [ Font.color (Element.rgb 0 0 0)
        , Font.size 18
        , Font.family
            [ Font.typeface "Open Sans"
            , Font.sansSerif
            ]
        , Element.width fill
        , centerX
        , Background.color color.white
        , shadow { offset = ( 0, 10 ), size = -1, blur = 15, color = color.dropShadow }
        ]
        [ Input.button
            [ alignLeft
            , Element.paddingXY 20 20
            , Font.semiBold
            , focused
                [ Background.color color.white ]
            ]
            { onPress = Just (NavigateTo "/"), label = text "Elm Parcel Starter" }
        , button [ paddingXY 10 20 ] (text "Home") (NavigateTo "/")
        , button [ paddingXY 10 20 ] (text "About") (NavigateTo "/about")
        , button [ paddingXY 10 20 ] (text "Users") (NavigateTo "/users")
        , el
            [ Element.below <|
                el
                    [ alignLeft
                    , Element.width <| px 150
                    , paddingXY 0 10
                    , Background.color color.white
                    , shadow { offset = ( 0, 10 ), size = -1, blur = 15, color = color.dropShadow }
                    , Element.Border.widthEach { top = 2, right = 0, bottom = 0, left = 0 }
                    , Element.Border.solid
                    , Element.Border.color <| rgb255 0xDF 0xDF 0xDF
                    , transparent <| not model.moreDropdownActive
                    ]
                <|
                    column [ Element.width fill ]
                        [ button [ Font.size 16, paddingXY 10 10, Element.width fill ] (text "First Element") NoOp
                        , button [ Font.size 16, paddingXY 10 10, Element.width fill ] (text "Second Element") NoOp
                        , button [ Font.size 16, paddingXY 10 10, Element.width fill ] (text "Third Element") NoOp
                        ]
            ]
            (button
                [ alignRight
                , paddingXY 10 10
                , onLoseFocus <| ShowMoreDropdown False
                , onClick <| ShowMoreDropdown <| not model.moreDropdownActive
                ]
                (row
                    []
                    [ text "More"
                    , el
                        [ paddingEach { top = 3, right = 0, bottom = 0, left = 5 } ]
                        (curvedDown <| [ SvgAttr.fill "#483fc7" ])
                    ]
                )
                NoOp
            )
        , el
            [ Element.below <|
                el
                    [ alignLeft
                    , Element.width <| px 250
                    , paddingXY 0 10
                    , Background.color color.white
                    , moveLeft 178
                    , shadow { offset = ( 0, 10 ), size = -1, blur = 15, color = color.dropShadow }
                    , Element.Border.widthEach { top = 2, right = 0, bottom = 0, left = 0 }
                    , Element.Border.solid
                    , Element.Border.color <| rgb255 0xDF 0xDF 0xDF
                    , transparent <| not model.loginActive
                    ]
                <|
                    column [ Element.width fill ]
                        [ el
                            [ Font.size 13
                            , paddingXY 10 10
                            , Element.width fill
                            ]
                            (Input.text [ Element.width <| maximum 300 fill ]
                                { onChange = TypedUsername
                                , text = model.userNameText
                                , label = Input.labelHidden "username"
                                , placeholder = Just <| Input.placeholder [] <| text "Username"
                                }
                            )
                        , el
                            [ Font.size 13
                            , paddingXY 10 10
                            , Element.width fill
                            ]
                            (Input.text [ Element.width <| maximum 300 fill ]
                                { onChange = TypedPassword
                                , text = model.passwordText
                                , label = Input.labelHidden "password"
                                , placeholder = Just <| Input.placeholder [] <| text "Password"
                                }
                            )
                        , Input.checkbox [ Font.size 13, paddingXY 10 10 ]
                            { onChange = ToggleShowPassword
                            , icon = Input.defaultCheckbox
                            , checked = model.showPassword
                            , label = Input.labelRight [] <| text "Show password"
                            }
                        ]
            , alignRight
            ]
            (button
                [ alignRight
                , paddingXY 10 20
                , onClick <| ShowLogin <| not model.loginActive
                ]
                (row [] [ text "Log In" ])
                NoOp
            )
        ]


topNavDropdownRow : Model -> Element Msg
topNavDropdownRow model =
    el
        [ Element.width <| px 300
        , height <| px 150
        , alignRight
        , Background.color <| color.blue
        ]
    <|
        el [ centerX, centerY ] <|
            text "Left"


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
