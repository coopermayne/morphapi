# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  name            :string
#  last_name       :string
#  birthday        :date
#  description     :text
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_morphosis    :boolean
#  is_employed     :boolean
#  is_collaborator :boolean
#  is_consultant   :boolean
#  start_date      :date
#  end_date        :date
#  website         :string
#  hit             :integer
#  location        :string
#  primary_id      :integer
#

class Person < ActiveRecord::Base
  include Primaryable

  validates :name, presence: true

  has_one :search_result, as: :searchable

  has_many :roles
  has_many :educations, dependent: :destroy
  has_and_belongs_to_many :bibliography_items

  accepts_nested_attributes_for :roles, allow_destroy: true
  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :uploads, allow_destroy: true

  def autocreate_searchable
    self.create_search_result
  end

  def update_search_content
    search_result.update_attributes(title: name, content: "#{roles.map(&:project).map(&:title).join(" ")}")
  end
end
