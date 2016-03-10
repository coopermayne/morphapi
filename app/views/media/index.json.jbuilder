json.totalPages @total_pages
json.currentPage @current_page
json.results @items do |item|
  json.uid item.class.name.first.downcase + item.id.to_s
  json.( item, :id, :title, :description, :overview, :created_at, :updated_at )
  json.image item.primary_image && item.primary_image.name
  json.documents item.getDocuments if !item.getDocuments.empty?

  if item.is_a? BibliographyItem
    json.( item, :title, :description, :overview, :author, :article_name, :book_title, :subtitle, :publication, :publisher, :date, :pub_date, :pages)

    #add document gallery

    json.types ["Bibliography"]
  elsif item.is_a? Project
    json.searchable_type "Project"
    json.searchable_id item.id
    json.pub_date item.getSuperDate
    json.types [item.section.title]
  end

end
