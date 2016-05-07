json.merge! @person.attributes 
json.primary_image @person.primary_image

json.educations @person.educations do |education|
  json.title education.title
end

json.roles_sorted @person.getRoles do |pos, roles|
  json.position_title pos
  json.roles roles.sort_by{|i| i.project.getSuperDate  }.reverse do |role|
    json.id role.project_id
    json.title role.project.title
    json.year role.project.getSuperDate
    json.section role.project.section.title
  end
end

json.roles @person.roles do |role|
  json.title role.position.title
  json.rank role.position.rank
  json.project do |json|
    json.id role.project.id
    json.title role.project.title
    json.section role.project.section.title
    json.image role.project.index_image.name
  end
end
