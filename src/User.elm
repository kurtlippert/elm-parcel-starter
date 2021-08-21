module User exposing (..)


type alias User =
    { id : Int
    , url : String
    , login : String
    , avatarUrl : String
    , gistsUrl : String
    , reposUrl : String
    }
