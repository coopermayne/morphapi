class NewsItem < ActiveRecord::Base
  belongs_to :news_type
  has_many :uploads
end
