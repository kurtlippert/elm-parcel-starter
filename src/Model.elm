module Model exposing (..)

import Browser.Navigation exposing (Key)
import Debounce exposing (Debounce)
import HttpRequest exposing (HttpRequest)
import Route exposing (Route)
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
    , loginActive : Bool
    , moreDropdownActive : Bool
    , userNameText : String
    , passwordText : String
    , showPassword : Bool
    }
