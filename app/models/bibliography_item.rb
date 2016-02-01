class BibliographyItem < ActiveRecord::Base
  has_and_belongs_to_many :projects

  has_many :uploads, as: :uploadable
  belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id
end
