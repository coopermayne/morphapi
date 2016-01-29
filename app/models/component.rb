class Component < ActiveRecord::Base
  belongs_to :project
  belongs_to :component_type
end
