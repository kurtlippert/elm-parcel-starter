module User exposing (..)


type alias User =
    { id : Int
    , url : String
    , login : String
    , avatarUrl : String
    , reposUrl : String
    }
