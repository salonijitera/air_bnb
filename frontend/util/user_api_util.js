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
