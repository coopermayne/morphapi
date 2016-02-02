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

require 'test_helper'

class AwardsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
end
