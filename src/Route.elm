module Route exposing (..)

import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)


type Route
    = Home
    | About
    | Users
    | Demo
    | DemoControl String
    | UserRoute Int
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map About (s "about")
        , map Users (s "users")
        , map Demo (s "demo")
        , map DemoControl (s "demo" </> string)
        , map UserRoute (s "users" </> int)
        ]


fromUrl : Url -> Route
fromUrl url =
    Maybe.withDefault NotFound (Url.Parser.parse routeParser url)
