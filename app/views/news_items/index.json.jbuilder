json.array! @news_items do |item|
  json.merge! item.attributes
  json.type item.news_type
  json.image item.primary_image
end
