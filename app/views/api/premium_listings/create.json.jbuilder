json.status @premium_listing.persisted? ? 200 : 422
if @premium_listing.persisted?
  json.premium_listing do
    json.id @premium_listing.id
    json.listing_name @premium_listing.listing_name
    json.listing_status @premium_listing.listing_status
    json.title @premium_listing.title
    json.description @premium_listing.description
    json.price @premium_listing.price
    json.status @premium_listing.status
    json.posted_date @premium_listing.posted_date
    json.user_id @premium_listing.user_id
  end
else
  json.errors @premium_listing.errors.full_messages
end
