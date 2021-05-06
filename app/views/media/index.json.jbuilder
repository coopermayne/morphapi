json.totalPages @total_pages
json.currentPage @current_page

if @items && @items.count>0
  json.results @items do |item|
    json.uid item.class.name.first.downcase + item.id.to_s
    json.( item, :id, :title, :description, :overview, :created_at, :updated_at )
    json.image item.primary_image && item.primary_image.name
    json.documents item.getDocuments if !item.getDocuments.empty?

    if item.is_a? BibliographyItem
      json.( item, :title, :description, :overview, :author, :article_name, :book_title, :subtitle, :publication, :publisher, :date, :pub_date, :pages)

      #add document gallery

      json.projects item.projects.each do |project|
        json.(project, :id, :title)
      end

      json.types ["Bibliography"]

    elsif item.is_a? Project
      json.searchable_type "Project"
      json.searchable_id item.id
      json.pub_date item.getSuperDate
      json.types [item.section.title]
    end

  end

elsif @awards && @awards.count > 0

  json.results @awards do |award|

    json.(award, :id, :title, :description, :overview, :year)
    json.projects award.projects.each do |project|
      json.(project, :id, :title)
    end

  end

else

  json.results @exhibitions do |ex|
    json.(ex, :id, :title)
  end

end
