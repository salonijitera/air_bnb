import { RECEIVE_CURRENT_USER, RECEIVE_USER_PROFILE, UPDATE_USER_PROFILE, CREATE_PROFILE_SUCCESS, CREATE_PROFILE_FAILURE } from '../actions/session_actions';
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
    case UPDATE_USER_PROFILE:
      newState[action.userProfile.user_id] = {...newState[action.userProfile.user_id], ...action.userProfile};
      return newState;
    case CREATE_PROFILE_SUCCESS:
      newState[action.profile.user_id] = {...newState[action.profile.user_id], ...action.profile};
      return newState;
    case CREATE_PROFILE_FAILURE:
      newState.error = action.error;
      return newState;
    default:
      return oldState;
  }
}
export default usersReducer;
