// Library imports
import { initializeApp } from 'firebase/app';
import 'firebase/auth';

// Styles
import './static/styles/main.scss';

// Local modules
import { initializeElmApp, observableFromElm } from './lib/elm';
import { config, authStateInit, onAuthStateChanged } from './lib/firebase';

// Initialize firebase
const app = initializeApp(config);

// Subsequent auth states
const onAuthStateChanged$ = onAuthStateChanged(app);

// Initialize Elm application on first auth state and then apply main application logic
authStateInit(app)
  .then(user => initializeElmApp({ user }))
  .then(elm => {
    const login$ = observableFromElm(elm.ports.login);
    const logout$ = observableFromElm(elm.ports.logout);
    const signup$ = observableFromElm(elm.ports.signup);

    onAuthStateChanged$.subscribe(elm.ports.onAuthStateChange.send);

    logout$.subscribe(() => {
      app.auth().signOut();
    });

    login$.subscribe(({ email, password }) => {
      app
        .auth()
        .signInWithEmailAndPassword(email, password)
        .then(res => {
          if (res.user) {
            console.log(res.user.email);
          }
        })
        .catch(elm.ports.loginFailed.send);
    });

    signup$.subscribe(({ email, password }) => {
      app
        .auth()
        .createUserWithEmailAndPassword(email, password)
        .then(res => {
          if (res.user) {
            console.log(res.user.email);
          }
        })
        .catch(elm.ports.signupFailed.send);
    });
  });
