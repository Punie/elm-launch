import { app as firebase } from 'firebase/app';
import { Observable, Observer } from 'rxjs';
import { skip, take } from 'rxjs/operators';

import { Elm } from '../elm/Main';

// Firebase config object
export const config = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  databaseURL: process.env.FIREBASE_DATABASE_URL,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID
};

export function authStateInit(app: firebase.App): Promise<Elm.User | null> {
  return authState(app)
    .pipe(take(1))
    .toPromise();
}

export function onAuthStateChanged(
  app: firebase.App
): Observable<Elm.User | null> {
  return authState(app).pipe(skip(1));
}

// app.auth().onAuthStateChanged as RxJS observable
function authState(app: firebase.App): Observable<Elm.User | null> {
  return Observable.create((observer: Observer<Elm.User | null>) => {
    app.auth().onAuthStateChanged(
      user => {
        if (user) {
          observer.next({
            displayName: user.displayName,
            email: user.email,
            photoURL: user.photoURL
          });
        } else {
          observer.next(null);
        }
      },
      error => {
        observer.error(error);
      },
      () => {
        observer.complete();
      }
    );
  });
}
