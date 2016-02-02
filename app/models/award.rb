class Award < ActiveRecord::Base
  has_and_belongs_to_many :projects

  belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id
  has_many :uploads, as: :uploadable

end
