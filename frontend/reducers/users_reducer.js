// PATH: /frontend/reducers/users_reducer.js
import { RECEIVE_CURRENT_USER, RECEIVE_USER_PROFILE } from '../actions/session_actions';
import { RECEIVE_HOST } from '../actions/user_actions';
import { merge } from 'lodash';
const defaultState = {};
const usersReducer = (oldState = defaultState, action) => {
  Object.freeze(oldState);
  let newState = merge({}, oldState);
  switch(action.type) {
    case RECEIVE_CURRENT_USER:
      newState[action.user.id] = action.user;
      return newState;
    case RECEIVE_HOST:
      newState[action.host.id] = action.host;
      return newState;
    case RECEIVE_USER_PROFILE:
      newState[action.userProfile.user_id] = {...newState[action.userProfile.user_id], ...action.userProfile};
      return newState;
    default:
      return oldState;
  }
}
export default usersReducer;
