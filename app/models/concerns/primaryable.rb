module Primaryable
  extend ActiveSupport::Concern

  included do
    has_many :uploads, as: :uploadable, dependent: :destroy
    belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id, dependent: :destroy
    before_save :set_uploads
  end

  def set_uploads
    if self.primary_image && !self.uploads.include?(self.primary_image)
      self.uploads << self.primary_image
    end
  end
end
