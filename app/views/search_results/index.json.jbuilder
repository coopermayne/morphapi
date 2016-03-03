i = 0
json.array! @results do |result|

  json.rank i
  json.(result, :content, :sorting_type, :section, :uid, :searchable_id, :searchable_type, :created_at, :title, :weight, :description)

  json.image result.thumb

  #json.section result.section
  
  i += 1
end
