module HttpRequest exposing (..)


type HttpRequest
    = Failure String
    | Loading
    | Success
    | NoOp
