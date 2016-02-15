# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  name            :string
#  last_name       :string
#  birthday        :date
#  description     :string
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
  has_many :roles
  has_many :educations

  has_many :uploads, as: :uploadable
  belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id

  accepts_nested_attributes_for :roles, allow_destroy: true
  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :uploads, allow_destroy: true
end
