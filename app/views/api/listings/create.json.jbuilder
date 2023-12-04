if @premium_listing.errors.any?
  json.error @premium_listing.errors.full_messages
else
  json.id @premium_listing.id
end
