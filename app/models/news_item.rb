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
  include Primaryable

  has_one :search_result, as: :searchable
  belongs_to :news_type

  accepts_nested_attributes_for :news_type

  def autocreate_searchable
    self.create_search_result
  end

  def update_search_content
    search_result.update_attributes(title: title, content: "")
  end
end
