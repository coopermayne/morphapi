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

  attr_accessor :make_primary, :make_index

  before_save :set_some_defaults

  mount_uploader :name, AvatarUploader

  belongs_to :file_type, optional: true
  belongs_to :credit, optional: true
  has_one :slide

  belongs_to :uploadable, polymorphic: true

  def make_primary
      self.uploadable && self.uploadable.primary_image == self
  end

  def make_primary=(val)
    if val=="1"
      self.uploadable.update({primary_image: self})
    elsif val=="0" && self.uploadable.primary_image == self
      self.uploadable.update({primary_image: nil})
    end
  end

  def make_index
    self.uploadable && self.uploadable.index_image == self
  end

  def make_index=(val)
    if val=="1"
      self.uploadable.update({index_image: self})
    elsif val=="0" && self.uploadable.index_image == self
      self.uploadable.update({index_image: nil})
    end
  end

  def is_image
    self.name_url && [".jpg", ".jpeg", ".png"].include?(File.extname(self.name_url).downcase)
  end

  def is_document
    self.name_url && [".pdf", ".doc"].include?(File.extname(self.name_url).downcase)
  end

  def set_some_defaults
    self.rank ||= 999
    if self.title.blank? && self.name_url
      self.title = File.basename(self.name_url, ".*")
    end
  end
end
