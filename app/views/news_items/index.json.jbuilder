json.array! @news_items do |item|

  json.(item, :id, :title)
  json.type item.news_type
  json.image item.primary_image

end
