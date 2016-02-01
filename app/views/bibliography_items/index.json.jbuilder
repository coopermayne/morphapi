json.array! @bibs do |bib|
  json.(bib, :id, :article_name, :author, :book_title, :date, :description, :subtitle, :title, :pub_date )
end
