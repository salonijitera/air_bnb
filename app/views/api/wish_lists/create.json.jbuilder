json.status 200
json.wish_list do
  json.id @wish_list.id
  json.name @wish_list.name
  json.user_id @wish_list.user_id
end
