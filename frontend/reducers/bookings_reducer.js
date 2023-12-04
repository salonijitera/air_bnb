// PATH: /frontend/reducers/bookings_reducer.js
import {
  RECEIVE_ALL_BOOKINGS,
  RECEIVE_BOOKINGS_BY_USER_ID,
  RECEIVE_BOOKINGS_BY_LISTING_ID,
  RECEIVE_BOOKING_BY_BOOKING_ID,
  REMOVE_BOOKING_BY_BOOKING_ID,
  RECEIVE_BOOKING,
  RECEIVE_BOOKING_ERRORS,
  BOOK_PROPERTY_SUCCESS,
  BOOK_PROPERTY_ERROR
} from '../actions/booking_actions';
import { merge } from 'lodash';
const bookingReducer = (oldState = {}, action) => {
  Object.freeze(oldState);
  let newState = merge({}, oldState);
  switch(action.type) {
    case RECEIVE_ALL_BOOKINGS:
      return action.bookings;
    case RECEIVE_BOOKINGS_BY_USER_ID:
      return action.bookings;
    case RECEIVE_BOOKINGS_BY_LISTING_ID:
      return action.bookings;
    case RECEIVE_BOOKING_BY_BOOKING_ID:
      return action.booking;
    case REMOVE_BOOKING_BY_BOOKING_ID:
      delete newState[action.bookingId];
      return newState;
    case RECEIVE_BOOKING:
      newState[action.booking.id] = action.booking;
      return newState;
    case RECEIVE_BOOKING_ERRORS:
      return { ...oldState, errors: action.errors };
    case BOOK_PROPERTY_SUCCESS:
      newState[action.booking.id] = action.booking;
      return newState;
    case BOOK_PROPERTY_ERROR:
      return { ...oldState, errors: action.errors };
    default:
      return oldState;
  }
}
export default bookingReducer;
