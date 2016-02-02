# == Schema Information
#
# Table name: component_types
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ComponentType < ActiveRecord::Base
  has_many :components
end
