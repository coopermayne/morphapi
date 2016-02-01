class Slide < ActiveRecord::Base
  belongs_to :section
  belongs_to :upload
end
