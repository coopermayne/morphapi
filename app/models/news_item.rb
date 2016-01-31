class NewsItem < ActiveRecord::Base
  belongs_to :news_type
  has_many :uploads, as: :uploadable
end
