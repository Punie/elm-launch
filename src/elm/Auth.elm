port module Auth exposing
    ( AuthInfo
    , CommonError(..)
    , LoginError(..)
    , SignupError(..)
    , fromLoginError
    , fromSignupError
    , login
    , logout
    , onAuthStateChange
    , onLoginFailed
    , onSignupFailed
    , signup
    )

import User exposing (User)


type alias AuthInfo =
    { email : String
    , password : String
    }


type alias AuthError =
    { code : String
    , message : String
    }


type CommonError
    = InvalidEmail String
    | Other String String


type LoginError
    = UserDisabled String
    | UserNotFound String
    | WrongPassword String
    | LoginError CommonError


type SignupError
    = EmailAlreadyInUse String
    | OperationNotAllowed String
    | WeakPassword String
    | SignupError CommonError


port login : AuthInfo -> Cmd msg


port loginFailed : (AuthError -> msg) -> Sub msg


port signup : AuthInfo -> Cmd msg


port signupFailed : (AuthError -> msg) -> Sub msg


port logout : () -> Cmd msg


port onAuthStateChange : (Maybe User -> msg) -> Sub msg


onLoginFailed : (LoginError -> msg) -> Sub msg
onLoginFailed toMsg =
    loginFailed (toMsg << toLoginError)


onSignupFailed : (SignupError -> msg) -> Sub msg
onSignupFailed toMsg =
    signupFailed (toMsg << toSignupError)


fromLoginError : LoginError -> String
fromLoginError error =
    case error of
        UserDisabled message ->
            message

        UserNotFound message ->
            message

        WrongPassword message ->
            message

        LoginError (InvalidEmail message) ->
            message

        LoginError (Other _ message) ->
            message


fromSignupError : SignupError -> String
fromSignupError error =
    case error of
        EmailAlreadyInUse message ->
            message

        OperationNotAllowed message ->
            message

        WeakPassword message ->
            message

        SignupError (InvalidEmail message) ->
            message

        SignupError (Other _ message) ->
            message



-- HELPERS


toLoginError : AuthError -> LoginError
toLoginError { code, message } =
    case code of
        "auth/invalid-email" ->
            LoginError (InvalidEmail message)

        "auth/user-disabled" ->
            UserDisabled message

        "auth/user-not-found" ->
            UserNotFound message

        "auth/wrong-password" ->
            WrongPassword message

        _ ->
            LoginError (Other code message)


toSignupError : AuthError -> SignupError
toSignupError { code, message } =
    case code of
        "auth/invalid-email" ->
            SignupError (InvalidEmail message)

        "auth/email-already-in-use" ->
            EmailAlreadyInUse message

        "auth/operation-not-allowed" ->
            OperationNotAllowed message

        "auth/weak-password" ->
            WeakPassword message

        _ ->
            SignupError (Other code message)
