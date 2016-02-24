# == Schema Information
#
# Table name: awards
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  overview    :text
#  hit         :integer
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  primary_id  :integer
#

class Award < ActiveRecord::Base
  include Primaryable

  has_one :search_result, as: :searchable
  has_and_belongs_to_many :projects

  def autocreate_searchable
    self.create_search_result
  end

  def update_search_content
    search_result.update_attributes(title: title, content: "#{projects.map(&:title).join(" ")}")
  end
end
