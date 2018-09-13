// Library imports
import { initializeApp } from 'firebase/app';
import 'firebase/auth';

// @ts-ignore
import hljs from 'highlight.js/lib/highlight.js';

// Styles
import './static/styles/main.scss';

// Local modules
import { initializeElmApp, observableFromElm, getWindowSize } from './lib/elm';
import { config, authStateInit, onAuthStateChanged } from './lib/firebase';

// Highlight JS
hljs.registerLanguage('elm', require('highlight.js/lib/languages/elm'));
hljs.registerLanguage('haskell', require('highlight.js/lib/languages/haskell'));
hljs.registerLanguage('javascript', require('highlight.js/lib/languages/javascript'));

(<any>window).hljs = hljs;
hljs.initHighlightingOnLoad();

// Initialize firebase
const app = initializeApp(config);

// Subsequent auth states
const onAuthStateChanged$ = onAuthStateChanged(app);

// Window initial size
const windowSize = getWindowSize();

// Initialize Elm application on first auth state and then apply main application logic
authStateInit(app)
  .then(user => initializeElmApp({ user, windowSize }))
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
        .catch(elm.ports.loginFailed.send);
    });

    signup$.subscribe(({ email, password }) => {
      app
        .auth()
        .createUserWithEmailAndPassword(email, password)
        .catch(elm.ports.signupFailed.send);
    });
  });
