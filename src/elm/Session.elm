module Session exposing
    ( Session
    , changes
    , init
    , isLoggedIn
    , navKey
    , user
    )

import Auth
import Browser.Navigation exposing (Key)
import User exposing (User)


type Session
    = LoggedIn Key User
    | Guest Key


init : Key -> Maybe User -> Session
init key maybeUser =
    case maybeUser of
        Just user_ ->
            LoggedIn key user_

        Nothing ->
            Guest key


navKey : Session -> Key
navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key


user : Session -> Maybe User
user session =
    case session of
        LoggedIn _ user_ ->
            Just user_

        Guest _ ->
            Nothing


isLoggedIn : Session -> Bool
isLoggedIn session =
    case session of
        LoggedIn _ _ ->
            True

        Guest _ ->
            False


changes : (Session -> msg) -> Key -> Sub msg
changes toMsg key =
    let
        toSessionMsg maybeUser =
            case maybeUser of
                Just val ->
                    toMsg (LoggedIn key val)

                Nothing ->
                    toMsg (Guest key)
    in
    Auth.onAuthStateChange toSessionMsg
