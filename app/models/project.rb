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
  include Clearcache
  include Searchable
  include Primaryable

  has_many :components
  has_many :roles, dependent: :destroy

  belongs_to :section, optional: true
  has_and_belongs_to_many :project_types, join_table: "projects_project_types"
  has_and_belongs_to_many :awards
  has_and_belongs_to_many :bibliography_items

  accepts_nested_attributes_for :roles, allow_destroy: true
  accepts_nested_attributes_for :awards, allow_destroy: true
  accepts_nested_attributes_for :bibliography_items, allow_destroy: true
  accepts_nested_attributes_for :components, allow_destroy: true

  #def select_parents_of_selected_kids
    #self.project_types.each do |pt|
      #pt.ancestors.each do |ancestor|
        #self.project_types << ancestor
      #end
    #end
  #end

  scope :with_section, -> (section_id) { where section_id: section_id }

  def date
    self.constr_edate || self.constr_sdate || self.design_edate || self.design_sdate
  end

  def getSuperDate
    self.constr_edate || self.constr_sdate || self.design_edate || self.design_sdate
  end

end
