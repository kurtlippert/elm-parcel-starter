module Msg exposing (..)

import Browser exposing (UrlRequest)
import Debounce
import Http
import HttpRequest exposing (HttpRequest)
import Url exposing (Url)
import User exposing (User)


type Msg
    = NoOp
    | ClickedButton String
    | ClickedLink UrlRequest
    | ChangedUrl Url
    | GettingUsers String
    | GotUsers (Result Http.Error (List User))
    | UserSearchInputChanged String
    | UserSearchInputDebouncer Debounce.Msg
    | SavedDebouncedUserSearchInput String
    | GotNewWidth Int
    | SelectedUser User
    | UnSelectedUser
    | ToggledBurgerMenu
    | ChangedHttpRequestStatus HttpRequest
