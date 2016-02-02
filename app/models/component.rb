# == Schema Information
#
# Table name: components
#
#  id                :integer          not null, primary key
#  content           :string
#  rank              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_id        :integer
#  component_type_id :integer
#

class Component < ActiveRecord::Base

  belongs_to :project

  belongs_to :component_type
  
end
