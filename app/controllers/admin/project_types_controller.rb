class Admin::ProjectTypesController < AdminController

  def index
    @project_types = ProjectType.where(nil)
    @project_types = @project_types
  end

  def show
    @project_type = ProjectType.find params[:id]
  end

  def new
    @project_type = ProjectType.new
  end

  def create
    @project_type = ProjectType.new project_type_params

    if @project_type.save
      flash[:notice] = 'Type item created'
      redirect_to admin_project_types_path
    else
      flash.now[:warning] = @project_type.errors.full_messages
      render :action => :new
    end
  end

  def update

    @project_type = ProjectType.find params[:id]

    if @project_type.update project_type_params
      flash[:notice] = 'Type item has been updated'
      redirect_to admin_project_type_path(@project_type)
    else
      flash.now[:warning] = @project_type.errors.full_messages
      render :action => :show
    end
  end

  def destroy
    @project_type = ProjectType.find params[:id]

    if @project_type.projects.count == 0
      @project_type.destroy
      flash[:notice] = 'Type item has been deleted'
    else
      flash[:notice] = 'Must be empty'
    end
    redirect_to admin_project_types_path
  end

  def rank
    pp = params[:project_types]
    ProjectType.update(pp.keys, pp.values)
    flash[:notice] = 'Type items have been updated'
    redirect_to admin_project_types_path
  end

  private

  def project_type_params
    params.require(:project_type).permit(
      :title,
      :section_id,
      :parent_id,
      :rank
    )
  end
end
