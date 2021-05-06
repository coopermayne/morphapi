json.array! @awards do |award|

  json.(award, :id, :title, :description, :overview, :year)
  json.projects award.projects.each do |project|
    json.(project, :id, :title)
  end

end
