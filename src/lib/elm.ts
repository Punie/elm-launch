import { Observable, Observer } from 'rxjs';

import { Elm } from '../elm/Main';

export function getWindowSize(): Elm.WindowSize {
  return {
    width: window.innerWidth,
    height: window.innerHeight
  };
}

export function initializeElmApp(flags: Elm.Flags): Elm.App {
  return Elm.Main.init({ flags });
}

export function observableFromElm<T>(cmd: Elm.Cmd<T>): Observable<T> {
  return Observable.create((observer: Observer<T>) => {
    cmd.subscribe(args => {
      observer.next(args);
    });
  });
}
