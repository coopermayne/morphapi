class Slide < ActiveRecord::Base
  has_one :section
  has_one :slide
end
