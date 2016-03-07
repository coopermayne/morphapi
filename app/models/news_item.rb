# == Schema Information
#
# Table name: news_items
#
#  id             :integer          not null, primary key
#  title          :string
#  description    :text
#  overview       :text
#  hit            :integer
#  place_name     :string
#  street_address :string
#  country        :string
#  city           :string
#  state          :string
#  zip            :integer
#  start_date     :date
#  end_date       :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  news_type_id   :integer
#  primary_id     :integer
#  in_news_box    :boolean          default(FALSE)
#

class NewsItem < ActiveRecord::Base
  include Searchable
  include Primaryable

  attr_accessor :address

  belongs_to :news_type

  accepts_nested_attributes_for :news_type

  def self.news_box_items
    self.where.not(primary_image: nil).where(in_news_box: true).order(created_at: :desc).map do |item|
      img = item.primary_image ? item.primary_image.name : nil
      {id: item.id, title: item.title, image: img }
    end
  end

end
