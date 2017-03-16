# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  name            :string
#  last_name       :string
#  birthday        :date
#  description     :text
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_morphosis    :boolean
#  is_employed     :boolean
#  is_collaborator :boolean
#  is_consultant   :boolean
#  start_date      :date
#  end_date        :date
#  website         :string
#  hit             :integer
#  location        :string
#  primary_id      :integer
#

class PeopleController < ApplicationController
  def index
    render json: Rails.cache.fetch('people', :expires_in => 30.days){
      @people = Person.includes(:primary_image).where(is_employed: true)
      render_to_string :index
    }
  end

  def show
    render json: Rails.cache.fetch("people#{params[:id]}", :expires_in => 30.days){
      @person = Person.includes(:educations, roles: [:position, :project]).find(params[:id])
      render_to_string :show
    }
  end
end
