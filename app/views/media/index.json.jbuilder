json.array! @items do |item|
  json.( item, :id, :title, :description, :overview, :created_at, :updated_at )
  json.image item.primary_image && item.primary_image.name
  json.documents item.getDocuments if !item.getDocuments.empty?

  if item.is_a? BibliographyItem
   json.( item, :title, :description, :overview, :author, :article_name, :book_title, :subtitle, :publication, :publisher, :date, :pub_date, :pages)

   #add document gallery

    json.types ["Bibliography"]
  elsif item.is_a? Project
    json.types [item.section.title]
  end

end
