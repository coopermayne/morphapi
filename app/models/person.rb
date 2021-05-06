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
  include Clearcache
  include Searchable
  include Primaryable

  validates :name, presence: true

  has_many :roles, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_and_belongs_to_many :bibliography_items

  accepts_nested_attributes_for :roles, allow_destroy: true
  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :uploads, allow_destroy: true

  def getRoles
    grouped = self.roles.group_by(&:position).sort_by{|pos, roles| pos.rank}
    res = {}
    grouped.each do |pair|
      res[pair[0].title] = pair[1]
    end
    res
  end
end
