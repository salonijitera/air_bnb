import axios from 'axios';
export const fetchListings = (filters) => {
  return $.ajax({
    method: "GET",
    url: `/api/listings?bounds=${JSON.stringify(filters.bounds)}`
  });
}
export const fetchListingsByUserId = userId => {
  return $.ajax({
    method: 'GET',
    url: `/api/listings?user_id=${userId}`
  })
}
export const fetchListing = id => {
  return $.ajax({
    method: 'GET',
    url: `/api/listings/${id}`
  });
}
export const createListing = listing => {
  return $.ajax({
    method: 'POST',
    url: `/api/listings`,
    data: { listing }
  });
}
export const updateListing = listing => {
  return $.ajax({
    method: 'PATCH',
    url: `/api/listings/${listing.id}`,
    data: { listing }
  });
}
export const deleteListing = id => {
  return $.ajax({
    method: 'DELETE',
    url: `/api/listings/${id}`
  });
}
export const createPremiumListing = premiumListingData => {
  return axios.post('/api/premium_listings', premiumListingData)
    .then(res => res.data);
}
export const deletePremiumListing = id => {
  return $.ajax({
    method: 'DELETE',
    url: `/api/premium_listing/${id}`
  }).fail(function(jqXHR, textStatus, errorThrown) {
    if(jqXHR.status === 422){
      alert("Wrong format");
    } else if(jqXHR.status === 404){
      alert("This premium listing is not found");
    }
  });
}
