class Role < ActiveRecord::Base
  belongs_to :person
  belongs_to :project
  belongs_to :position
end
