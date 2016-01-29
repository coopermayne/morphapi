class Person < ActiveRecord::Base
  has_many :roles
  has_many :educations

  has_many :uploads
end
