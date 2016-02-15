# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rank       :integer
#  content    :text
#

class Section < ActiveRecord::Base
  has_many :projects
  has_many :slides
  has_many :project_types
end
