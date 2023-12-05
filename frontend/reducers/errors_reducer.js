// PATH: /frontend/reducers/errors_reducer.js
import { combineReducers } from 'redux';
import sessionErrorsReducer from './session_errors_reducer';
import localexperienceErrorsReducer from './localexperience_errors_reducer';
const errorsReducer = combineReducers({
  session: sessionErrorsReducer,
  localexperience: localexperienceErrorsReducer
});
export default errorsReducer;
