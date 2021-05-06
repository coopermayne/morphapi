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

class AwardsController < ApplicationController
  def index
    @awards = Award.includes(:primary_image, :projects)
  end

  def show
    @award = Award.find(params[:id])
  end
end
