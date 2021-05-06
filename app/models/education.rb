# == Schema Information
#
# Table name: educations
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :integer
#

class Education < ActiveRecord::Base
  include Clearcache
  belongs_to :person
end
