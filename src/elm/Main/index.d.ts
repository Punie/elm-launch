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

  export interface Ports {
  }

  export interface App {
    ports: Ports;
  }

  export namespace Main {
    export function init(config: {
      node: HTMLElement | null
    }): App;
  }
}
