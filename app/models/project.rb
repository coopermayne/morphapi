# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string
#  overview       :text
#  description    :text
#  program        :text
#  client         :string
#  size           :integer
#  site_area      :decimal(, )
#  lat            :decimal(, )
#  lon            :decimal(, )
#  street_address :string
#  zip            :integer
#  design_sdate   :date
#  design_edate   :date
#  constr_sdate   :date
#  constr_edate   :date
#  open_date      :date
#  close_date     :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  section_id     :integer
#  height         :integer
#  hit            :integer
#  city           :string
#  state          :string
#  country        :string
#  primary_id     :integer
#

class Project < ActiveRecord::Base


  has_many :components
  has_many :roles
  accepts_nested_attributes_for :roles, allow_destroy: true


  belongs_to :section
  has_and_belongs_to_many :project_types, join_table: "projects_project_types"
  has_and_belongs_to_many :awards
  has_and_belongs_to_many :bibliography_items

  has_many :uploads, as: :uploadable
  belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id


  def getGalleries
    grouped = self.uploads.select{|u| u.in_gallery}.group_by{|item| item.file_type}
    res = {}
    grouped.each{ |k, v| res[k.title.to_sym] = v }
    res
  end

  def getAllGalleries
    grouped = self.uploads.select{|u| u.isImage }.group_by{|item| item.file_type}
    res = {}
    grouped.each{ |k, v| res[k.title.to_sym] = v.sort_by{|u| u.rank} }
    res
  end

  scope :with_section, -> (section_id) { where section_id: section_id }

end
