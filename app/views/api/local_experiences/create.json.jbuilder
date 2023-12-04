json.status 200
json.local_experience do
  json.id @local_experience.id
  json.title @local_experience.title
  json.description @local_experience.description
  json.location @local_experience.location
  json.price @local_experience.price
  json.date @local_experience.date
  json.image_url url_for(@local_experience.image) if @local_experience.image.attached?
end
