class Admin::ProjectsController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    @section_id = params[:section_id]
    @projects = Project.where(nil)
    @projects = @projects.with_section(@section_id) if @section_id
    @projects = @projects.order(sort_column+ " " + sort_direction).paginate :page => params[:page]
  end

  def show
    @casein_page_title = 'View project'
    @project = Project.includes(:section, :project_types, roles:[:position, :person], uploads: [:file_type]).find params[:id]
  end

  def new
    @casein_page_title = 'Add a new project'
    @project = Project.new
  end

  def create
    @project = Project.new project_params

    if @project.save
      flash[:notice] = 'Project created'
      redirect_to admin_projects_path
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
      redirect_to admin_projects_path
    else
      flash.now[:warning] = 'There were problems when trying to update this project'
      render :action => :show
    end
  end

  def destroy
    @project = Project.find params[:id]

    @project.destroy
    flash[:notice] = 'Project has been deleted'
    redirect_to admin_projects_path
  end

  private

  def project_params
    params.require(:project).permit(
      :title,
      :overview,
      :description,
      :program,
      :client,
      :size,
      :site_area,
      :lat,
      :lon,
      :street_address,
      :zip,
      :design_sdate,
      :design_edate,
      :constr_sdate,
      :constr_edate,
      :open_date,
      :close_date,
      :height,
      :section_id,
      project_type_ids: [],
      roles_attributes: [
        :id,
        :_destroy,
        :person_id,
        :project_id,
        :position_id
      ],
      awards_attributes: [
        :id,
        :_destroy,
        :title,
        :description,
        :overview,
      ],
      bibliography_items_attributes: [
        :id,
        :_destroy,
        :title,
        :description,
        :overview, 
        :author,  
        :article_name, 
        :book_title,   
        :subtitle,     
        :publication,  
        :publisher,    
        :date, 
        :pub_date 
      ],
      uploads_attributes: [
        :id,
        :_destroy,
        :file_type_id,
        :rank,
        :in_gallery,
        :title,
        :name,
      ]
    )
  end

  private

  def sort_column
    Project.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
