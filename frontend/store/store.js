import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import logger from 'redux-logger';
import rootReducer from '../reducers/root_reducer';
import usersReducer from '../reducers/users_reducer';
const rootReducer = combineReducers({
  // other reducers
  users: usersReducer,
});
const configureStore = (preloadedState = {}) => {
  return createStore(
    rootReducer, 
    preloadedState, 
    applyMiddleware(thunk)
    // applyMiddleware(thunk, logger)
  );
}
export default configureStore;
