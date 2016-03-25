json.array! @people do |person|
  json.(person, :id, :name, :last_name, :description)
  json.image person.primary_image && person.primary_image.name
end
