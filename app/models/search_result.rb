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
  attr_accessor :rank
  belongs_to :searchable, polymorphic: true, optional:true
  #searchable modeles include; Award, BibliographyItem, NewsItem, Person, Project

  def self.search(search)
    search = search.downcase

    results = where("lower(title) LIKE ?", "%#{search}%") + where("lower(content) LIKE ?", "%#{search}%")
    ranked = Hash.new(0)

    results.each do |result|
      ranked[result] += 1
      ranked[result] += 1 if result.searchable_type == "Project"
    end

    ranked.to_a.sort_by{|item| item[1]}.reverse.slice(0,100).map(&:first)
  end
end
