module Model exposing (..)

import Browser.Navigation exposing (Key)
import Debounce exposing (Debounce)
import HttpRequest exposing (HttpRequest)
import Url exposing (Url)
import User exposing (User)


type alias Model =
    { httpRequest : HttpRequest
    , users : List User
    , userSearchInput : String
    , userSearchInputDebouncer : Debounce String
    , report : List String
    , selectedUser : Maybe User
    , burgerMenuActive : Bool
    , key : Key
    , url : Url
    , screenWidth : Int
    }
