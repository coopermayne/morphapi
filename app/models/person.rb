class Person < ActiveRecord::Base
  has_many :roles
  has_many :educations

  has_many :uploads, as: :uploadable
  belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id
end
