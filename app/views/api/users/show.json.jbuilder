json.extract! @user, :id, :is_vip
json.status response.status
json.error response.error if response.error.present?
