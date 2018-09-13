/* Elm Type Definitions */

export namespace Elm {
  /* Commands and Subscriptions */

  export interface Cmd<T> {
    subscribe(callback: (value: T) => void): void;
    unsubscribe(callback: (value: T) => void): void;
  }

  export interface Sub<T> {
    send(value: T): void;
  }

  /* App Types */

  export interface AuthInfo {
    email: string;
    password: string;
  }

  export interface AuthError {
    code: string;
    message: string;
  }

  export interface User {
    displayName: string | null;
    email: string | null;
    photoURL: string | null;
  }

  export interface WindowSize {
    width: number;
    height: number;
  }

  export interface Flags {
    user: User | null;
    windowSize: WindowSize;
  }

  export interface Ports {
    login: Cmd<AuthInfo>;
    loginFailed: Sub<AuthError>;
    signup: Cmd<AuthInfo>;
    signupFailed: Sub<AuthError>;
    logout: Cmd<void>;
    onAuthStateChange: Sub<User | null>;
  }

  export interface Config {
    node?: HTMLElement | null;
    flags: Flags;
  }

  export interface App {
    ports: Ports;
  }

  export namespace Main {
    export function init(config: Config): App;
  }
}
