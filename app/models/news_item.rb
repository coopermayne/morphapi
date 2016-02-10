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
#

class NewsItem < ActiveRecord::Base
  belongs_to :news_type

  has_many :uploads, as: :uploadable
  belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id

  accepts_nested_attributes_for :news_type
end
