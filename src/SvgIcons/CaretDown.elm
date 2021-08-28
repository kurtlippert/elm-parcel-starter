module SvgIcons.CaretDown exposing (..)

import Element exposing (Element, html)
import Html
import Svg exposing (path, svg, text)
import Svg.Attributes as SvgAttr


caretDown : List (Html.Attribute msg) -> Element msg
caretDown moreAttributes =
    html
        (svg
            (List.concat
                [ moreAttributes
                , [ SvgAttr.height "16"
                  , SvgAttr.width "16"
                  , SvgAttr.viewBox "0 0 1000 1000"
                  ]
                ]
            )
            [ Svg.metadata []
                [ text "IcoFont Icons" ]
            , Svg.title []
                [ text "caret-down" ]
            , Svg.glyph
                [ SvgAttr.glyphName "caret-down"
                , SvgAttr.unicode "\u{EA67}"
                , SvgAttr.horizAdvX "1000"
                ]
                []
            , path
                [ SvgAttr.d "M534.3 637.5l254.80000000000007-254.8c18.899999999999977-18.899999999999977 12.600000000000023-34.30000000000001-14.200000000000045-34.30000000000001h-549.8c-26.80000000000001 0-33.10000000000002 15.300000000000011-14.200000000000017 34.30000000000001l254.79999999999998 254.8c19 18.899999999999977 49.599999999999966 18.899999999999977 68.59999999999997 0z"
                ]
                []
            ]
        )
