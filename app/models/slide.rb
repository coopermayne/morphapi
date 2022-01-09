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
  include Clearcache

  belongs_to :section, optional: true
  belongs_to :project, optional: true

  has_many :uploads, as: :uploadable, dependent: :destroy

  belongs_to :image, class_name: 'Upload', foreign_key: :image_upload_id
  belongs_to :mp4, class_name: 'Upload', foreign_key: :vida_upload_id
  belongs_to :webm, class_name: 'Upload', foreign_key: :vidb_upload_id
  belongs_to :gif, class_name: 'Upload', foreign_key: :gif_upload_id

  accepts_nested_attributes_for :image, :mp4, :webm, :gif
  #, :reject_if => proc { |att| att['id'].blank? && att['name'].blank? }

  #validations
  validates :section_id, presence: true
  #validates :image, presence: {message: "must be present"}
  #validates :mp4, :webm, :gif, presence: {message: "must be present for home page section"}, if: :is_on_home_page?

  #hooks
  before_save :set_uploads

  #methods
  def is_on_home_page?
    self.section.title == "Home Page"
  end

  def video_slides_valid?
    self.image.name_url && ['jpg', 'jpeg', 'png'].include?(self.image.name.file.extension.downcase)
    self.mp4 && self.mp4.name.file.extension == 'mp4'
    self.webm && self.webm.name.file.extension == 'webm'
    self.gif && self.gif.name.file.extension == 'gif'
  end

  def self.get_all_slides
    all_slides = self.where(:visible => true).includes(:section, :project, :image, :mp4, :webm, :gif).all.group_by(&:section)
    all_slides.keys.each { |k| all_slides[ k.title ] = all_slides.delete(k)}
    all_slides.each do |section, slide_array|
      has_title = !(["Home Page", "Morphosis"].include? section)
      slide_array.sort_by!{|sli| sli.rank || 9999 }
      slide_array.map! do |slide|
        {
          project_id: slide.project_id,
          rank: slide.rank,
          project_title: has_title ? slide.title : nil,
          image: slide.image && slide.image.name,
          mp4: slide.mp4 && slide.mp4.name,
          webm: slide.webm && slide.webm.name,
          gif: slide.gif && slide.gif.name
        }
      end
    end
    all_slides
  end


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

  scope :with_section, -> (section_id) { where section_id: section_id }

end
