module Primaryable
  # using this module... Project, Award, BibliographyItem, Person, NewsItem
  
  extend ActiveSupport::Concern

  included do

    has_many :uploads, as: :uploadable, dependent: :destroy
    belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id
    belongs_to :index_image, class_name: 'Upload', foreign_key: :index_image_id
    before_save :set_uploads
    accepts_nested_attributes_for :uploads, allow_destroy: true
    accepts_nested_attributes_for :primary_image
    accepts_nested_attributes_for :index_image
  end

  def set_uploads
    if self.primary_image && !self.uploads.include?(self.primary_image)
      self.uploads << self.primary_image
    end
  end

  def getGalleries
    grouped = self.uploads.select{|u| u.in_gallery && u.is_image && u.file_type}.group_by{|item| item.file_type}.sort_by{|k,v| k.rank}
    res = {}
    grouped.each{ |sorted| res[sorted[0].title.to_sym] = sorted[1].sort_by(&:rank) }
    res
  end

  def getAllGalleries
    grouped = self.uploads.select{|u| u.is_image }.group_by{|item| item.file_type}
    res = {}
    grouped.each{ |k, v| res[k.title.to_sym] = v.sort_by(&:rank) }
    res
  end

  def getDocuments
    self.uploads.select{|u| u.is_document}
  end

end
