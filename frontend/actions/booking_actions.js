// PATH: /frontend/actions/booking_actions.js
import * as BookingApiUtil from '../util/booking_api_util';
export const RECEIVE_ALL_BOOKINGS = 'RECEIVE_ALL_BOOKINGS';
export const RECEIVE_BOOKINGS_BY_USER_ID = 'RECEIVE_BOOKINGS_BY_USER_ID';
export const RECEIVE_BOOKINGS_BY_LISTING_ID = 'RECEIVE_BOOKINGS_BY_LISTING_ID';
export const RECEIVE_BOOKING_BY_BOOKING_ID = 'RECEIVE_BOOKING_BY_BOOKING_ID';
export const RECEIVE_BOOKING_ERRORS = 'RECEIVE_BOOKING_ERRORS';
export const REMOVE_BOOKING_BY_BOOKING_ID = 'REMOVE_BOOKING_BY_BOOKING_ID';
export const BOOK_PROPERTY = 'BOOK_PROPERTY';
export const BOOK_PROPERTY_SUCCESS = 'BOOK_PROPERTY_SUCCESS';
export const BOOK_PROPERTY_ERROR = 'BOOK_PROPERTY_ERROR';
// Regular action creators
const receiveAllBookings = bookings => {
  return ({
    type: RECEIVE_ALL_BOOKINGS,
    bookings: bookings
  });
} 
const receiveBookingByBookingId = booking => {
  return ({
    type: RECEIVE_BOOKING_BY_BOOKING_ID,
    booking: booking
  });
} 
const receiveBookingsByUserId = bookings => {
  return ({
    type: RECEIVE_BOOKINGS_BY_USER_ID,
    bookings: bookings
  });
} 
const receiveBookingsByListingId = bookings => {
  return ({
    type: RECEIVE_BOOKINGS_BY_LISTING_ID,
    bookings: bookings
  });
} 
const receiveBookingErrors = errors => {
  return ({
    type: RECEIVE_BOOKING_ERRORS,
    errors: errors
  });
}
const removeBookingByBookingId = booking => {
  return ({
    type: REMOVE_BOOKING_BY_BOOKING_ID,
    bookingId: booking.id
  });
} 
const bookPropertySuccess = bookingDetails => {
  return ({
    type: BOOK_PROPERTY_SUCCESS,
    bookingDetails: bookingDetails
  });
}
const bookPropertyError = error => {
  return ({
    type: BOOK_PROPERTY_ERROR,
    error: error
  });
}
// Thunk action creators
export const fetchAllBookings = () => dispatch => {
  return BookingApiUtil.fetchAllBookings()
    .then(bookings => dispatch(receiveAllBookings(bookings)));
}
export const fetchBookingByBookingId = bookingId => dispatch => {
  return BookingApiUtil.fetchBookingByBookingId(bookingId)
    .then(booking => dispatch(receiveBookingByBookingId(booking)));
}
export const fetchBookingsByUserId = userId => dispatch => {
  return BookingApiUtil.fetchBookingsByUserId(userId)
    .then(bookings => dispatch(receiveBookingsByUserId(bookings)));
}
export const fetchBookingsByListingId = listingId => dispatch => {
  return BookingApiUtil.fetchBookingsByListingId(listingId)
    .then(bookings => dispatch(receiveBookingsByListingId(bookings)));
}
export const createBooking = (userId, propertyId) => dispatch => {
  return BookingApiUtil.createBooking(userId, propertyId)
    .then(booking => dispatch(receiveBookingByBookingId(booking)))
    .catch(err => dispatch(receiveBookingErrors(err)));
}
export const deleteBooking = bookingId => dispatch => {
  return BookingApiUtil.deleteBooking(bookingId)
    .then(booking => dispatch(removeBookingByBookingId(booking)));
}
export const bookProperty = bookingDetails => dispatch => {
  return BookingApiUtil.bookProperty(bookingDetails)
    .then(response => dispatch(bookPropertySuccess(response)))
    .catch(err => dispatch(bookPropertyError(err)));
}
