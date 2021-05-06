json.merge! @award.attributes
json.image @award.primary_image
  
json.projects @award.projects.each do |project|
  json.(project, :id, :title)
  json.image project.primary_image
end
