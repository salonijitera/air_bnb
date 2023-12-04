export const fetchAllBookings = () => {
  return $.ajax({
    method: 'GET',
    url: `/api/bookings`
  })
}
export const fetchBookingByBookingId = bookingId => {
  return $.ajax({
    method: 'GET',
    url: `/api/bookings/${bookingId}`
  })
}
export const fetchBookingsByUserId = userId => {
  return $.ajax({
    method: 'GET',
    url: `/api/bookings?userId=${userId}`
  })
}
export const fetchBookingsByListingId = listingId => {
  return $.ajax({
    method: 'GET',
    url: `/api/bookings?listingId=${listingId}`
  });
}
export const createBooking = booking => {
  return $.ajax({
    method: 'POST',
    url: `/api/bookings`,
    data: { booking }
  })
}
export const deleteBooking = bookingId => {
  return $.ajax({
    method: 'DELETE',
    url: `/api/bookings/${bookingId}`
  });
}
export const bookProperty = bookingDetails => {
  return fetch(`/api/properties/${bookingDetails.id}/book`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      user_id: bookingDetails.user_id,
      date_from: bookingDetails.date_from,
      date_to: bookingDetails.date_to
    })
  })
  .then(response => {
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return response.json();
  })
  .catch(error => {
    console.error('There was an error!', error);
  });
}
