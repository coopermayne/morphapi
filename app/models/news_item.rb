class NewsItem < ActiveRecord::Base
  belongs_to :news_type

  has_many :uploads, as: :uploadable
  belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id
end
