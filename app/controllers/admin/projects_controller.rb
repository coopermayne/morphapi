class Admin::ProjectsController < AdminController

  def index
    @title = "Projects"
    @section_id = params[:type]
    @projects = Project.includes(:section, :primary_image).where(nil)
    @projects = @projects.with_section(@section_id) if @section_id
    @projects = @projects.order(created_at: :desc)
  end

  def show
    @edit_files = params["uploads"]
    @title = "Edit Project"
    @project = Project.includes(:section, :project_types, roles:[:position, :person], uploads: [:file_type]).find params[:id]
  end

  def new
    @title = "New Project"
    @project = Project.new
  end

  def create
    @project = Project.new project_params

    if @project.save
      flash[:notice] = 'Project created'
      redirect_to admin_project_path(@project)
    else
      flash.now[:warning] = 'There were problems when trying to create a new project'
      render :action => :new
    end
  end

  def update
    @project = Project.find params[:id]

    if @project.update_attributes project_params
      flash[:notice] = 'Project has been updated'
      #redirect_to admin_projects_path
      redirect_to admin_project_path(@project)
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
      :address,
      :city,
      :state,
      :country,
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
        primary_image_attributes: [
          :id,
          :name
        ],
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
        :pub_date,
        primary_image_attributes: [
          :id,
          :name
        ]
      ],
			components_attributes: [
				:id,
				:_destroy,
				:title,
				:rank,
				:content,
			],
      uploads_attributes: [
        :id,
        :_destroy,
        :file_type_id,
        :rank,
        :in_gallery,
        :title,
        :name,
        :credit_id,
        :copyright,
        :make_primary,
        :make_index
      ]
    )
  end

end
