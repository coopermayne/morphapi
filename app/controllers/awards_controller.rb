class AwardsController < ApplicationController
  def index
    @awards = Award.all
    render json: @awards
  end

  def show
    @award = Award.find(params[:id])
    render json: @award
  end
end
