json.status 200
json.wish_list do
  json.extract! @wish_list, :id, :name
end
