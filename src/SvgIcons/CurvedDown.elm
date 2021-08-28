module SvgIcons.CurvedDown exposing (..)

import Element exposing (Element, html)
import Html
import Svg exposing (path, svg, text)
import Svg.Attributes as SvgAttr


curvedDown : List (Html.Attribute msg) -> Element msg
curvedDown moreAttributes =
    html
        (svg
            (List.concat
                [ moreAttributes
                , [ SvgAttr.height "24"
                  , SvgAttr.width "24"
                  , SvgAttr.viewBox "0 0 1000 1000"
                  ]
                ]
            )
            [ Svg.metadata []
                [ text "IcoFont Icons" ]
            , Svg.title []
                [ text "curved-down" ]
            , Svg.glyph
                [ SvgAttr.glyphName "curved-down"
                , SvgAttr.unicode "\u{EA73}"
                , SvgAttr.horizAdvX "1000"
                ]
                []
            , path
                [ SvgAttr.d "M792.5 431.7l-51.799999999999955-27.30000000000001c-10-5.2999999999999545-26.300000000000068-5.2999999999999545-36.40000000000009 0l-186.0999999999999 98.20000000000005c-10.000000000000057 5.2999999999999545-26.300000000000068 5.2999999999999545-36.400000000000034 0l-186.10000000000002-98.20000000000005c-10-5.2999999999999545-26.30000000000001-5.2999999999999545-36.39999999999998 0l-51.80000000000001 27.30000000000001c-10 5.300000000000011-10 13.900000000000034 0 19.19999999999999l274.3 144.70000000000005c10 5.2999999999999545 26.30000000000001 5.2999999999999545 36.400000000000034 0l274.29999999999995-144.70000000000005c10-5.2999999999999545 10-13.899999999999977 0-19.19999999999999z"
                ]
                []
            ]
        )
