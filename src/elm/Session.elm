module Session exposing
    ( Session
    , changes
    , init
    , isLoggedIn
    , user
    )

import Auth
import User exposing (User)


type Session
    = LoggedIn User
    | Guest


init : Maybe User -> Session
init maybeUser =
    case maybeUser of
        Just user_ ->
            LoggedIn user_

        Nothing ->
            Guest


user : Session -> Maybe User
user session =
    case session of
        LoggedIn user_ ->
            Just user_

        Guest ->
            Nothing


isLoggedIn : Session -> Bool
isLoggedIn session =
    case session of
        LoggedIn _ ->
            True

        Guest ->
            False


changes : (Session -> msg) -> Sub msg
changes toMsg =
    let
        toSessionMsg maybeUser =
            case maybeUser of
                Just val ->
                    toMsg (LoggedIn val)

                Nothing ->
                    toMsg Guest
    in
    Auth.onAuthStateChange toSessionMsg
