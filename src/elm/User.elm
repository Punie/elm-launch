module User exposing (User)


type alias User =
    { displayName : Maybe String
    , email : Maybe String
    , photoURL : Maybe String
    }
