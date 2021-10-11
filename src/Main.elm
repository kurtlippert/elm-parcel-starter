module Main exposing (main)

-- import HttpRequest.HttpRequest exposing (Loading)

import Browser
import Browser.Events exposing (onResize)
import Browser.Navigation as Nav exposing (Key)
import Content exposing (content)
import Debounce
import Debug exposing (toString)
import Element exposing (Element, centerX, centerY, column, el, fill, height, layout, padding, text, width)
import Footer exposing (footer)
import Http
import HttpRequest
import Json.Decode exposing (Decoder)
import Json.Encode
import Model exposing (Model)
import Msg exposing (Msg(..))
import Route exposing (Route(..), fromUrl, routeParser)
import Task
import Topnav exposing (topNav)
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)
import User exposing (User)



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }



-- FLAGS


type alias Flags =
    { windowWidth : Int }



-- INIT


emptyUser : User
emptyUser =
    { id = 0
    , url = ""
    , login = ""
    , avatarUrl = ""
    , reposUrl = ""
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( { httpRequest = HttpRequest.Loading
      , users = []
      , userSearchInput = ""
      , userSearchInputDebouncer = Debounce.init
      , report = []
      , selectedUser = Nothing
      , burgerMenuActive = False
      , key = key
      , url = url
      , screenWidth = flags.windowWidth
      , loginActive = False
      , moreDropdownActive = False
      , userNameText = ""
      , passwordText = ""
      , showPassword = False
      }
    , getUsersRequest 0 5 ""
    )



-- HELPERS


getUsersRequest : Int -> Int -> String -> Cmd Msg
getUsersRequest skip take filter =
    let
        -- urlAndFilter : (Url.Url, Bool)
        ( url, decoder ) =
            if filter == "" then
                ( { protocol = Url.Https
                  , host = "api.github.com"
                  , port_ = Nothing
                  , path = "/users"
                  , query =
                        Just <|
                            "since="
                                ++ String.fromInt skip
                                ++ "&per_page="
                                ++ String.fromInt take
                  , fragment = Nothing
                  }
                , usersDecoder
                )

            else
                ( { protocol = Url.Https
                  , host = "api.github.com"
                  , port_ = Nothing
                  , path = "/search/users"
                  , query =
                        Just <|
                            "q="
                                ++ filter
                                ++ "&since="
                                ++ String.fromInt skip
                                ++ "&per_page="
                                ++ String.fromInt take
                  , fragment = Nothing
                  }
                , usersFilterDecoder
                )
    in
    -- let
    --     _ =
    -- Debug.log "url" <| Url.toString url
    -- _ = 'nothing'
    -- in
    Http.request
        { method = "GET"
        , headers = []
        , url = Url.toString url
        , body = Http.emptyBody
        , expect = Http.expectJson GotUsers decoder
        , timeout = Nothing
        , tracker = Nothing
        }



-- TYPE ALIAS, DECODERS / ENCODERS


userDecoder : Decoder User
userDecoder =
    Json.Decode.map5 User
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "url" Json.Decode.string)
        (Json.Decode.field "login" Json.Decode.string)
        (Json.Decode.field "avatar_url" Json.Decode.string)
        (Json.Decode.field "repos_url" Json.Decode.string)


usersDecoder : Decoder (List User)
usersDecoder =
    Json.Decode.list userDecoder


usersFilterDecoder : Decoder (List User)
usersFilterDecoder =
    Json.Decode.field "items" usersDecoder


userEncoder : User -> Json.Encode.Value
userEncoder user =
    Json.Encode.object
        [ ( "id", Json.Encode.int user.id )
        , ( "url", Json.Encode.string user.url )
        , ( "login", Json.Encode.string user.login )
        , ( "avatar_url", Json.Encode.string user.avatarUrl )
        , ( "repos_url", Json.Encode.string user.reposUrl )
        ]


{-| This defines how the debouncer should work.
Choose the strategy for your use case.
-}
debounceConfig : (Debounce.Msg -> Msg) -> Debounce.Config Msg
debounceConfig debounceMsg =
    { strategy = Debounce.later 700
    , transform = debounceMsg
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedHttpRequestStatus httpRequest ->
            ( { model | httpRequest = httpRequest }, Cmd.none )

        ClickedLink urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        NavigateTo href ->
            ( model, Nav.pushUrl model.key href )

        ShowLogin trueOrFalse ->
            ( { model | loginActive = trueOrFalse }, Cmd.none )

        ToggleShowPassword trueOrFalse ->
            ( { model | showPassword = trueOrFalse }, Cmd.none )

        ShowMoreDropdown trueOrFalse ->
            ( { model | moreDropdownActive = trueOrFalse }, Cmd.none )

        TypedUsername s ->
            ( { model | userNameText = s }, Cmd.none )

        TypedPassword s ->
            ( { model | passwordText = s }, Cmd.none )

        ChangedUrl url ->
            case fromUrl url of
                Route.NotFound ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | url = url }
                    , Cmd.none
                    )

        GettingUsers query ->
            ( { model | httpRequest = HttpRequest.Loading }, getUsersRequest 0 5 query )

        UserSearchInputChanged userSearchInput ->
            let
                ( newDebouncer, cmd ) =
                    Debounce.push
                        (debounceConfig UserSearchInputDebouncer)
                        userSearchInput
                        model.userSearchInputDebouncer
            in
            ( { model
                | userSearchInput = userSearchInput
                , userSearchInputDebouncer = newDebouncer
              }
            , cmd
            )

        UserSearchInputDebouncer msg_ ->
            let
                ( debouncer, cmd ) =
                    Debounce.update
                        (debounceConfig UserSearchInputDebouncer)
                        (Debounce.takeLast saveDebouncedUserSearchInput)
                        msg_
                        model.userSearchInputDebouncer
            in
            ( { model | userSearchInputDebouncer = debouncer }, cmd )

        GotUsers response ->
            case response of
                Ok users ->
                    ( { model | httpRequest = HttpRequest.Success, users = users }, Cmd.none )

                Err err ->
                    case err of
                        Http.BadBody errorMessage ->
                            ( { model | httpRequest = HttpRequest.Failure errorMessage }
                            , Cmd.none
                            )

                        _ ->
                            ( model, Cmd.none )

        SelectedUser user ->
            ( { model | selectedUser = Just user }, Cmd.none )

        UnSelectedUser ->
            ( { model | selectedUser = Nothing }, Cmd.none )

        ToggledBurgerMenu ->
            ( { model | burgerMenuActive = not model.burgerMenuActive }, Cmd.none )

        SavedDebouncedUserSearchInput _ ->
            ( model, getUsersRequest 0 5 model.userSearchInput )

        ClickedButton id ->
            let
                _ =
                    Debug.log "Clicked" id
            in
            ( model, Cmd.none )

        GotNewWidth newWidth ->
            let
                _ =
                    Debug.log "Screen Width" newWidth
            in
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- SAVE (for debouncer)


saveDebouncedUserSearchInput : String -> Cmd Msg
saveDebouncedUserSearchInput s =
    Task.perform SavedDebouncedUserSearchInput (Task.succeed s)



-- SUBS


subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize (\w h -> GotNewWidth w)


router : Model -> Element Msg
router model =
    case fromUrl model.url of
        About ->
            el [ padding 20, centerX, centerY ] <| text "about"

        Users ->
            el [ padding 20, centerX, centerY ] <| text "users"

        Demo ->
            content model ""

        DemoControl controlName ->
            content model controlName

        NotFound ->
            el [ padding 20, centerX, centerY ] <| text "Not Found"

        _ ->
            el [ padding 20, centerX, centerY ] <| text "generic"


view : Model -> Browser.Document Msg
view model =
    let
        _ =
            Debug.log "URL" model.url
    in
    { title = "Elm Parcel Starter"
    , body =
        [ layout [ width fill, height fill ] <|
            column [ width fill ]
                [ topNav model
                , router model
                , footer
                ]
        ]
    }
