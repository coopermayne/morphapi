json.array! @projects do |project|

  json.(project, :id, :title, :lat, :lon, :constr_edate, :design_edate )

  json.image project.primary_image.name

  if project.section
    json.section project.section, :title
  end

  json.types project.project_types.map{|t| t.title}

end
