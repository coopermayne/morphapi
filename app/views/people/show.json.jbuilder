json.merge! @person.attributes 
json.primary_image @person.primary_image

json.educations @person.educations do |education|
  json.title education.title
end

json.roles @person.roles do |role|
  json.title role.position.title
  json.project do |json|
    json.id = role.project.id
    json.title = role.project.title
  end
end
