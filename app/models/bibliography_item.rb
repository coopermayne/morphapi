# == Schema Information
#
# Table name: bibliography_items
#
#  id           :integer          not null, primary key
#  title        :string
#  description  :text
#  overview     :text
#  hit          :integer
#  author       :string
#  article_name :string
#  book_title   :string
#  subtitle     :string
#  publication  :string
#  publisher    :string
#  date         :string
#  pub_date     :date
#  pages        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  primary_id   :integer
#

class BibliographyItem < ActiveRecord::Base
  include Primaryable

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :people

  has_one :search_result, as: :searchable

  def autocreate_searchable
    self.create_search_result
  end

  def update_search_content
    search_result.update_attributes(title: title, content: "#{projects.map(&:title).join(" ")} #{article_name}")
  end
end
