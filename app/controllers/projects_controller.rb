class ProjectsController < ApplicationController

  def index
    @projects = Project.includes(:primary_image, :project_types, :section)
  end

  def show
    @project = Project.includes(roles: :person, uploads: [ :file_type ]).find(params[:id])
  end
end
