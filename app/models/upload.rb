# == Schema Information
#
# Table name: uploads
#
#  id              :integer          not null, primary key
#  name            :string
#  copyright       :boolean
#  rank            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string
#  file_type_id    :integer
#  credit_id       :integer
#  uploadable_id   :integer
#  uploadable_type :string
#  in_gallery      :boolean
#  is_featured     :boolean
#

class Upload < ActiveRecord::Base
  mount_uploader :name, AvatarUploader

  belongs_to :file_type
  belongs_to :credit
  #has_one :slide

  belongs_to :uploadable, polymorphic: true

  def is_image
    [".jpg", ".jpeg", ".png"].include? File.extname(self.name_url)
  end
end
