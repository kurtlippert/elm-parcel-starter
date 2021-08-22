module Main exposing (main)

-- import HttpRequest.HttpRequest exposing (Loading)

import Browser
import Browser.Navigation as Nav exposing (Key)
import Content exposing (content)
import Debounce exposing (Debounce)
import Element exposing (fill, layout, minimum, row, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html
    exposing
        ( Html
        , a
        , b
        , br
        , button
        , div
        , figure
        , hr
        , img
        , input
        , nav
        , p
        , span
        , table
        , tbody
        , td
        , text
        , th
        , thead
        , time
        , tr
        )
import Html.Attributes
    exposing
        ( alt
        , attribute
        , class
        , classList
        , datetime
        , height
        , href
        , id
        , placeholder
        , scope
        , src
        , type_
        , value
        , width
        )
import Html.Events exposing (onClick, onInput)
import Http
import HttpRequest exposing (HttpRequest)
import Json.Decode exposing (Decoder, field, string)
import Json.Encode
import Model exposing (Model)
import Msg exposing (Msg(..))
import Route exposing (Route)
import Task exposing (Task)
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
      }
    , getUsersRequest 0 5 ""
    )



-- HELPERS


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Route.Home top
        , map Route.About (s "about")
        , map Route.Users (s "users")
        , map Route.UserRoute (s "users" </> int)
        ]


fromUrl : Url -> Route
fromUrl url =
    Maybe.withDefault Route.NotFound (Url.Parser.parse routeParser url)


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


usersEncoder : List User -> Json.Encode.Value
usersEncoder users =
    Json.Encode.list userEncoder users


{-| Maybe a little misleading because we don't actually care about all of the model
Only the bits that have value printing out to the dev console
Note: currently only using this to print out the model ('PrintModel' message)
-}
modelEncoder : Model -> Json.Encode.Value
modelEncoder model =
    Json.Encode.object
        [ ( "users", usersEncoder model.users )
        , ( "selectedUser", userEncoder <| getSomeUser model.selectedUser )
        ]


getSomeUser : Maybe User -> User
getSomeUser maybeUser =
    case maybeUser of
        Just user ->
            user

        Nothing ->
            emptyUser


isUserSelected : Maybe User -> Bool
isUserSelected maybeUser =
    case maybeUser of
        Just _ ->
            True

        Nothing ->
            False



-- UPDATE


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

        SavedDebouncedUserSearchInput s ->
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
    Sub.none



-- VIEW
-- topNav : Model -> Html Msg
-- topNav model =
--     nav [ class "navbar is-light" ]
--         [ div [ class "navbar-brand" ]
--             [ a [ class "navbar-item font-weight-bold", href "/" ]
--                 [ text "Elm Parcel Starter" ]
--             , span
--                 [ classList
--                     [ ( "navbar-burger burger", True )
--                     , ( "is-active", model.burgerMenuActive )
--                     ]
--                 , attribute "data-target" "mainNavbar"
--                 , onClick ToggleBurgerMenu
--                 ]
--                 [ span [] []
--                 , span [] []
--                 , span [] []
--                 ]
--             ]
--         , div
--             [ classList
--                 [ ( "navbar-menu", True )
--                 , ( "is-active", model.burgerMenuActive )
--                 ]
--             , id "mainNavbar"
--             ]
--             [ div [ class "navbar-start" ]
--                 [ a [ class "navbar-item", href "/" ]
--                     [ text "Home" ]
--                 , a [ class "navbar-item", href "/about" ]
--                     [ text "About" ]
--                 , a [ class "navbar-item", href "/users" ]
--                     [ text "Users" ]
--                 ]
--             ]
--         ]
-- userTable : Model -> List String -> Html Msg
-- userTable model classes =
--     div [ class <| String.join " " classes ]
--         [ div [ class "form-group" ]
--             [ input [ class "input", placeholder "Filter", type_ "text", value model.userSearchInput, onInput GetUsersInput ]
--                 []
--             ]
--         , table [ class "table is-hoverable is-fullwidth mt-3" ]
--             [ thead []
--                 [ tr []
--                     [ th [ scope "col" ] [ text "ID" ]
--                     , th [ scope "col" ] [ text "Url" ]
--                     , th [ scope "col" ] [ text "Login" ]
--                     , th [ scope "col" ] [ text "Avatar" ]
--                     ]
--                 ]
--             , tbody []
--                 (List.map
--                     (\user ->
--                         tr [ onClick <| SelectUser user ]
--                             [ td [ class "align-middle" ] [ text <| String.fromInt user.id ]
--                             , td [ class "align-middle" ] [ text user.url ]
--                             , td [ class "align-middle" ] [ text user.login ]
--                             , td [ class "align-middle" ] [ img [ src user.avatarUrl, height 42, width 42 ] [] ]
--                             ]
--                     )
--                     model.users
--                 )
--             ]
--         , div
--             [ classList
--                 [ ( "modal", True )
--                 , ( "is-active", isUserSelected model.selectedUser )
--                 ]
--             ]
--             [ div [ class "modal-background", onClick UnSelectUser ] []
--             , div [ class "modal-content" ]
--                 [ div [ class "card" ]
--                     [ userContent <|
--                         getSomeUser model.selectedUser
--                     ]
--                 ]
--             , button [ class "modal-close is-large", onClick UnSelectUser ]
--                 []
--             ]
--         ]


{-| Right now just the content for the modal popup
We could reuse this for the "users/:userId" route
-}



-- userContent : User -> Html Msg
-- userContent user =
--     div [ class "card-content" ]
--         [ div [ class "media" ]
--             [ div [ class "media-left" ]
--                 [ figure [ class "image is-48x48" ]
--                     [ img [ alt "Placeholder image", src user.avatarUrl ]
--                         []
--                     ]
--                 ]
--             , div [ class "media-content" ]
--                 [ p [ class "title is-4" ]
--                     [ text user.login ]
--                 , p [ class "subtitle is-6" ]
--                     [ text "@johnsmith" ]
--                 ]
--             ]
--         , div [ class "content" ]
--             [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec iaculis mauris."
--             , a []
--                 [ text "@bulmaio" ]
--             , text ".      "
--             , a [ href "#" ]
--                 [ text "#css" ]
--             , a [ href "#" ]
--                 [ text "#responsive" ]
--             , br []
--                 []
--             , time [ datetime "2016-1-1" ]
--                 [ text "11:09 PM - 1 Jan 2016" ]
--             ]
--         ]


isNotFailure : HttpRequest -> Bool
isNotFailure httpRequest =
    case httpRequest of
        HttpRequest.Failure _ ->
            False

        _ ->
            True



-- notification : Model -> Html Msg
-- notification model =
--     case model.httpRequest of
--         Failure message ->
--             div
--                 [ classList
--                     [ ( "notification is-danger", True )
--                     , ( "d-none", isNotFailure model.httpRequest )
--                     ]
--                 ]
--                 [ button
--                     [ class "delete"
--                     , onClick <| ChangeHttpRequestStatus NoOp
--                     ]
--                     []
--                 , text message
--                 ]
--         _ ->
--             div [] []


{-| The reason I've added the 'userTable' to all views (just hidden)
is a hacky solution to getting the spacing to be consistent across
all the views. If you remove it you'll see the spacing change from route to route
-}
mainContent : Model -> Route -> Html Msg
mainContent model route =
    case route of
        Route.Home ->
            div []
                [ text "Welcome Home!"

                -- , userTable model [ "invisible" ]
                ]

        Route.About ->
            div []
                [ text "This is the 'About' page"

                -- , userTable model [ "invisible" ]
                ]

        Route.Users ->
            -- userTable model []
            div [] [ text "This is the 'Users' page" ]

        Route.UserRoute userId ->
            div []
                [ text <| "User ID: " ++ String.fromInt userId
                , br [] []
                , text "(in future, make http request to get user info)"
                ]

        _ ->
            -- div [] [ text "Page Not Found!", userTable model [ "invisible" ] ]
            div [] [ text "Page Not Found!" ]


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Parcel Starter"
    , body =
        [ topNav model

        -- , content model
        -- , mainContent model Route.Home
        -- , div [ class "container m-5" ]
        --     [ text "The current URL is: "
        --     , b [] [ text (Url.toString model.url) ]
        --     , hr [] []
        --     , mainContent model (fromUrl model.url)
        --     , notification model
        --     ]
        ]
    }
