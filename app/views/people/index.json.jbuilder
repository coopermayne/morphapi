json.array @people do |person|
  json.(person, :id, :name, :is_employed)
end
