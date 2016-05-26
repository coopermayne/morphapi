#temp remove
#ex = NewsType.find_by_title "Exhibitions"
json.array! @news_items do |item|
  #temp remove
  #if ex
    #next if item.news_type_id == ex.id
  #end
  json.merge! item.attributes
  json.type item.news_type
  json.image item.primary_image
end
