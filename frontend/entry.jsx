import React from 'react';
import ReactDOM from 'react-dom';
import 'normalize.css';

import Root from './components/root';

import { signUp, logIn, logOut } from './actions/session_actions';
import { fetchListings } from './actions/listing_actions';
import configureStore from './store/store';

// import { fetchListings } from './util/listing_api_util';

document.addEventListener('DOMContentLoaded', () => {
  const root = document.getElementById('root');

  let store;
  if (window.currentUser) {
    const preloadedState = {
      entities: {
        users: { [window.currentUser.id]: window.currentUser }
      },
      session: {id: window.currentUser.id }
    };
    store = configureStore(preloadedState);
    delete window.currentUser;
  } else {
    store = configureStore();
  }

  // TESTING START
  window.getState = store.getState;
  window.dispatch = store.dispatch;
  window.signUp = signUp;
  window.logIn = logIn;
  window.logOut = logOut;
  window.fetchListings = fetchListings;
  // TESTING END

  ReactDOM.render(
    <Root store={store} />,
    root  
  );
});

