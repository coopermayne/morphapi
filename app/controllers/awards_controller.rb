class AwardsController < ApplicationController
  def index
    @awards = Award.includes(:primary_image, :projects)
  end

  def show
    @award = Award.find(params[:id])
  end
end
