# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rank       :integer
#  content    :text
#

class Section < ActiveRecord::Base
  has_many :projects
  has_many :slides
  has_many :project_types

  accepts_nested_attributes_for :project_types

  def pcontact
    if self.contact
      self.contact.gsub(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/) {|w| "<a href='mailto:" + w +"' target='_blank'>"+ w +"</a>"}
    end
  end

  def pemployment
    if self.employment
      self.employment.gsub(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/) {|w| "<a href='mailto:" + w +"' target='_blank'>"+ w +"</a>"}
    end
  end

  def pabout
    if self.about
      self.about.gsub(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/) {|w| "<a href='mailto:" + w +"' target='_blank'>"+ w +"</a>"}
    end
  end

  def get_slides
		has_title = !(["Home Page", "Morphosis"].include? self.title)

    self.slides.select(&:visible).sort_by(&:rank).map do |slide|
      {
        project_id: slide.project_id,
        rank: slide.rank,
        project_title:  has_title ? slide.title : nil,
        image: slide.image && slide.image.name,
        mp4: slide.mp4 && slide.mp4.name,
        webm: slide.webm && slide.webm.name,
        gif: slide.gif && slide.gif.name
      }
    end
  end

  def get_types

    project_types.select{|pt| pt.ancestry.nil?}.sort_by{|pt| pt.rank}.map do |pt|
      {
        title: pt.title,
        children: pt.children.sort_by{|ch| ch.rank}.map{|ch| { title: ch.title } }
      }
    end
  end
end
