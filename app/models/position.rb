# == Schema Information
#
# Table name: positions
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rank       :integer
#

class Position < ActiveRecord::Base
  include Clearcache
  has_many :roles
  before_save :set_rank

  def set_rank
    if self.rank.nil?
      self.rank=9999
    end
  end
end
