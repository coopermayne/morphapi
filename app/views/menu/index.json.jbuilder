json.array! @sections do |section|
  json.(section, :id, :title)
  json.slides section.slides
end
