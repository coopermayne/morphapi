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

  has_many :uploads, as: :uploadable

  belongs_to :image, class_name: 'Upload', foreign_key: :image_upload_id
  belongs_to :mp4, class_name: 'Upload', foreign_key: :vida_upload_id
  belongs_to :webm, class_name: 'Upload', foreign_key: :vidb_upload_id
  belongs_to :gif, class_name: 'Upload', foreign_key: :gif_upload_id
end
