# == Schema Information
#
# Table name: slides
#
#  id              :integer          not null, primary key
#  rank            :integer
#  visible         :boolean
#  is_image        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  section_id      :integer
#  image_upload_id :integer
#  vida_upload_id  :integer
#  vidb_upload_id  :integer
#  gif_upload_id   :integer
#  project_id      :integer
#  title           :string
#

class Slide < ActiveRecord::Base
  before_save :set_uploads

  belongs_to :section
  belongs_to :project

  has_many :uploads, as: :uploadable, dependent: :destroy

  belongs_to :image, class_name: 'Upload', foreign_key: :image_upload_id
  belongs_to :mp4, class_name: 'Upload', foreign_key: :vida_upload_id
  belongs_to :webm, class_name: 'Upload', foreign_key: :vidb_upload_id
  belongs_to :gif, class_name: 'Upload', foreign_key: :gif_upload_id

  private

  def set_uploads
    if self.image && !self.uploads.include?(self.image)
      self.uploads << self.image
    end
    if self.mp4 && !self.uploads.include?(self.mp4)
      self.uploads << self.mp4
    end
    if self.webm && !self.uploads.include?(self.webm)
      self.uploads << self.webm
    end
    if self.gif && !self.uploads.include?(self.gif)
      self.uploads << self.gif
    end
  end

end
