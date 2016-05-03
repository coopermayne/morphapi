json.merge! @person.attributes 
json.primary_image @person.primary_image

json.educations @person.educations do |education|
  json.title education.title
end

json.roles @person.getRoles do |pos, roles|
  json.position_title pos
  json.roles roles do |role|
    json.id role.project_id
    json.title role.project.title
    json.section role.project.section.title
  end
end
