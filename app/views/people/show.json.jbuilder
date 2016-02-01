json.merge! @person.attributes 

json.roles @person.roles do |role|
  json.title role.position.title
  json.project do |json|
    json.id = role.project.id
    json.title = role.project.title
  end
end
