json.array! @items do |item|
  json.( item, :id, :title )
  json.image item.primary_image && item.primary_image.name

  if item.is_a? BibliographyItem
    json.( item, :author, :article_name, :book_title, :subtitle, :publication, :publisher, :date, :pub_date, :pages)
    json.types "Bibliography"
  elsif item.is_a? Project
    json.types item.project_types.map(&:title)
  end

end
