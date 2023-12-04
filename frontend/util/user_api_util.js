export const fetchHost = hostId => {
  return $.ajax({
    method: "GET",
    url: `/api/users?host_id=${hostId}`
  });
};
export const shareWishList = (id, email) => {
  if (typeof id !== 'number') {
    throw new Error('Wrong format');
  }
  if (!/^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/.test(email)) {
    throw new Error('Invalid email format');
  }
  return $.ajax({
    method: "POST",
    url: `/api/wish_lists/${id}/share`,
    data: { email }
  });
};
export const updateUserProfile = (profileData) => {
  if (!profileData.user_id || !profileData.first_name || !profileData.last_name || !profileData.date_of_birth || !profileData.profile_picture) {
    throw new Error('Missing required fields');
  }
  if (!/^\d{4}-\d{2}-\d{2}$/.test(profileData.date_of_birth)) {
    throw new Error('Invalid date format');
  }
  return $.ajax({
    method: "PATCH",
    url: `/api/users/${profileData.user_id}/update_profile`,
    data: profileData
  });
};
export const createProfile = (userId, profileData) => {
  if (typeof userId !== 'number') {
    throw new Error('Wrong format');
  }
  if (!profileData.first_name) {
    throw new Error('The first name is required.');
  }
  if (!profileData.last_name) {
    throw new Error('The last name is required.');
  }
  if (!profileData.date_of_birth || !/^\d{4}-\d{2}-\d{2}$/.test(profileData.date_of_birth)) {
    throw new Error('The date of birth is not in valid format.');
  }
  if (!profileData.profile_picture) {
    throw new Error('The profile picture is required.');
  }
  return $.ajax({
    method: "POST",
    url: `/api/users/${userId}/profile`,
    data: profileData
  });
};
