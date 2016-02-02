# == Schema Information
#
# Table name: awards
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  overview    :text
#  hit         :integer
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  primary_id  :integer
#

class Award < ActiveRecord::Base
  has_and_belongs_to_many :projects

  belongs_to :primary_image, class_name: 'Upload', foreign_key: :primary_id
  has_many :uploads, as: :uploadable

end
