json.status 200
json.profile do
  json.id @profile.id
  json.first_name @profile.first_name
  json.last_name @profile.last_name
  json.date_of_birth @profile.date_of_birth
  json.profile_picture url_for(@profile.profile_picture)
  json.user_id @profile.user_id
end
