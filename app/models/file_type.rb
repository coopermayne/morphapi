# == Schema Information
#
# Table name: file_types
#
#  id         :integer          not null, primary key
#  title      :string
#  slug       :string
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FileType < ActiveRecord::Base
  has_many :uploads
end
