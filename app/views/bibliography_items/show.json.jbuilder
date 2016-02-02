json.merge! @bib.attributes
json.projects @bib.projects.each do |project|
  json.id project.id
  json.title project.title
end
