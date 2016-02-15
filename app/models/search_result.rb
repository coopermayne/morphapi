# == Schema Information
#
# Table name: search_results
#
#  id              :integer          not null, primary key
#  content         :text
#  title           :string
#  searchable_id   :integer
#  searchable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class SearchResult < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true
  #searchable modeles include; Award, BibliographyItem, NewsItem, Person, Project
  

end
