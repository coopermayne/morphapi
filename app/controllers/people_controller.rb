class PeopleController < ApplicationController
  def index
    @people = Person.includes(:primary_image).where(is_employed: true)
  end

  def show
    @person = Person.includes(roles: [:position, :project]).find(params[:id])
  end
end
