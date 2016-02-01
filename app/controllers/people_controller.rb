class PeopleController < ApplicationController
  def index
    @people = Person.all.select{|p| p.is_morphosis && p.is_employed}
  end

  def show
    @person = Person.find(params[:id])
  end
end
