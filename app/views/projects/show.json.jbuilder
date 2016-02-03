#json.(@project, :id, :title, :overview, :description, :program, :client, :size, :site_area, :lat)
json.result do |json|
  json.merge! @project.attributes
  json.primary_image @project.primary_image

  #json.components @project.components, :id, :content, :rank, :component_type

  json.uploads @project.uploads do |upload|
    json.(upload, :id, :title, :rank )
    json.url upload.name.url
    json.type upload.file_type, :title, :rank
    json.credit upload.credit
  end

  json.people @project.roles do |role|
    json.person role.person, :id, :name, :last_name, :is_morphosis, :is_collaborator, :is_consultant
  end

  json.awards @project.awards, :id, :title, :year
  json.bibliography_items @project.bibliography_items, :id, :title, :pub_date
end
