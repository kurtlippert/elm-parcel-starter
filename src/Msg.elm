module Msg exposing (..)

import Browser exposing (UrlRequest)
import Debounce
import Http
import HttpRequest exposing (HttpRequest)
import Route exposing (Route)
import Url exposing (Url)
import User exposing (User)


type Msg
    = NoOp
    | ClickedButton String
    | ClickedLink UrlRequest
    | ChangedUrl Url
    | NavigateTo String
    | ShowLogin Bool
    | ShowMoreDropdown Bool
    | TypedUsername String
    | TypedPassword String
    | GettingUsers String
    | GotUsers (Result Http.Error (List User))
    | UserSearchInputChanged String
    | UserSearchInputDebouncer Debounce.Msg
    | SavedDebouncedUserSearchInput String
    | GotNewWidth Int
    | SelectedUser User
    | UnSelectedUser
    | ToggledBurgerMenu
    | ToggleShowPassword Bool
    | ChangedHttpRequestStatus HttpRequest
