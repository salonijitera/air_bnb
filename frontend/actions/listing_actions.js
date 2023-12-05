// PATH: /frontend/actions/listing_actions.js
import * as ListingApiUtil from '../util/listing_api_util';
export const RECEIVE_ALL_LISTINGS = 'RECEIVE_ALL_LISTINGS';
export const RECEIVE_LISTING = 'RECEIVE_LISTING';
export const REMOVE_LISTING = 'REMOVE_LISTING';
export const RECEIVE_LOCAL_EXPERIENCE = 'RECEIVE_LOCAL_EXPERIENCE';
export const RECEIVE_LOCAL_EXPERIENCE_ERRORS = 'RECEIVE_LOCAL_EXPERIENCE_ERRORS';
// Regular action creators
const receiveAllListings = (listings) => {
  return ({
    type: RECEIVE_ALL_LISTINGS,
    listings: listings
  });
};
const receiveListing = listing => {
  return ({
    type: RECEIVE_LISTING,
    listing: listing
  });
}
const removeListing = listing => {
  return ({
    type: REMOVE_LISTING,
    listingId: listing.id
  });
}
const receiveLocalExperience = localExperience => {
  return ({
    type: RECEIVE_LOCAL_EXPERIENCE,
    localExperience: localExperience
  });
}
const receiveLocalExperienceErrors = errors => {
  return ({
    type: RECEIVE_LOCAL_EXPERIENCE_ERRORS,
    errors: errors
  });
}
// Thunk action creators
export const fetchListings = (filters) => dispatch => {
  return ListingApiUtil.fetchListings(filters)
    .then(listings => dispatch(receiveAllListings(listings)));
};
export const fetchListingsByUserId = userId => dispatch => {
  return ListingApiUtil.fetchListingsByUserId(userId)
    .then(listings => dispatch(receiveAllListings(listings)));
}
export const fetchListing = id => dispatch => {
  return ListingApiUtil.fetchListing(id)
    .then(listing => dispatch(receiveListing(listing)));
};
export const createListing = listing => dispatch => {
  return ListingApiUtil.createListing(listing)
    .then(listing => dispatch(receiveListing(listing)));
};
export const updateListing = listing => dispatch => {
  return ListingApiUtil.updateListing(listing)
    .then(listing => dispatch(receiveListing(listing)));
};
export const deleteListing = id => dispatch => {
  return ListingApiUtil.deleteListing(id)
    .then(listing => dispatch(removeListing(listing)));
};
export const createLocalExperience = localExperience => dispatch => {
  return ListingApiUtil.createLocalExperience(localExperience)
    .then(localExperience => dispatch(receiveLocalExperience(localExperience)))
    .catch(err => dispatch(receiveLocalExperienceErrors(err.response.data)));
};
