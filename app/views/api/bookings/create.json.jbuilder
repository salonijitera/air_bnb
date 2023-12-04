json.status 200
json.booking do
  json.id @booking.id
  json.property_id @booking.property_id
  json.user_id @booking.user_id
  json.date_from @booking.date_from
  json.date_to @booking.date_to
end
