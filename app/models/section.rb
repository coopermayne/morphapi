class Section < ActiveRecord::Base
  has_many :projects
  has_many :slides

  has_many :children, class_name: "Section", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "Section"
end
