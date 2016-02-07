# Scaffolding generated by Casein v5.1.1.5

module Casein
  class ProjectsController < Casein::CaseinController

    ## optional filters for defining usage according to Casein::AdminUser access_levels
    # before_filter :needs_admin, :except => [:action1, :action2]
    # before_filter :needs_admin_or_current_user, :only => [:action1, :action2]
  
    def index
      @casein_page_title = 'Projects'

      @section_id = params[:section_id]

      @projects = Project.where(nil)
      @projects = @projects.with_section(@section_id) if @section_id
  		@projects = @projects.order(sort_order(:title)).paginate :page => params[:page]
    end
  
    def show
      @casein_page_title = 'View project'
      @project = Project.find params[:id]
    end
  
    def new
      @casein_page_title = 'Add a new project'
    	@project = Project.new
    end

    def create
      @project = Project.new project_params
    
      if @project.save
        flash[:notice] = 'Project created'
        redirect_to casein_projects_path
      else
        flash.now[:warning] = 'There were problems when trying to create a new project'
        render :action => :new
      end
    end
  
    def update
      @casein_page_title = 'Update project'
      
      @project = Project.find params[:id]
    
      if @project.update_attributes project_params
        flash[:notice] = 'Project has been updated'
        redirect_to casein_projects_path
      else
        flash.now[:warning] = 'There were problems when trying to update this project'
        render :action => :show
      end
    end
 
    def destroy
      @project = Project.find params[:id]

      @project.destroy
      flash[:notice] = 'Project has been deleted'
      redirect_to casein_projects_path
    end
  
    private
      
      def project_params
        params.require(:project).permit(:title, :overview, :description, :program, :client, :size, :site_area, :lat, :lon, :street_address, :zip, :design_sdate, :height, :section_id, roles_attributes: [:id, :_destroy, :person_id, :project_id, :position_id])
      end

  end
end
