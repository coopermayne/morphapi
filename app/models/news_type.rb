# == Schema Information
#
# Table name: news_types
#
#  id         :integer          not null, primary key
#  title      :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NewsType < ActiveRecord::Base
  has_many :news_items
end
