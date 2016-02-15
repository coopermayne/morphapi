# == Schema Information
#
# Table name: search_results
#
#  id              :integer          not null, primary key
#  content         :text
#  title           :string
#  searchable_id   :integer
#  searchable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class SearchResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
