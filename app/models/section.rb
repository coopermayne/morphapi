# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#  rank       :integer
#  content    :text
#

class Section < ActiveRecord::Base
  has_many :projects
  has_many :slides

  has_many :children, class_name: "Section", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "Section"
end
