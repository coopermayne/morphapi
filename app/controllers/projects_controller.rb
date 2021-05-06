# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string
#  overview       :text
#  description    :text
#  program        :text
#  client         :string
#  size           :integer
#  site_area      :decimal(, )
#  lat            :decimal(, )
#  lon            :decimal(, )
#  street_address :string
#  zip            :integer
#  design_sdate   :date
#  design_edate   :date
#  constr_sdate   :date
#  constr_edate   :date
#  open_date      :date
#  close_date     :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  section_id     :integer
#  height         :integer
#  hit            :integer
#  city           :string
#  state          :string
#  country        :string
#  primary_id     :integer

class ProjectsController < ApplicationController
  def index
    render json: Rails.cache.fetch('projects', :expires_in => 30.days){
      @projects = Project.includes(:primary_image, :project_types, :section, :components)
      render_to_string :index
    }
  end

  def show
    render json: Rails.cache.fetch("projects#{params[:id]}", :expires_in => 30.days){
      @project = Project.includes(roles: [:position, :person ], uploads: [ :file_type, :credit ], bibliography_items: [:primary_image]).find(params[:id])
      render_to_string :show
    }
  end
end
