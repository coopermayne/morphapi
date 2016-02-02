# == Schema Information
#
# Table name: slides
#
#  id         :integer          not null, primary key
#  rank       :integer
#  visible    :boolean
#  is_image   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  upload_id  :integer
#  section_id :integer
#

class Slide < ActiveRecord::Base
  belongs_to :section
  belongs_to :upload
end
