json.array! @bibs do |bib|
  json.(bib, :id, :article_name, :author, :book_title, :date, :description, :subtitle, :title, :pub_date )
  json.image bib.primary_image
end
