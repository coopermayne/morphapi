class SearchResult < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true
  #searchable modeles include; Award, BibliographyItem, NewsItem, Person, Project
  

end
