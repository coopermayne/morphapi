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
      flash.now[:warning] = 'There were problems when trying to create a new Type item'
      render :action => :new
    end
  end

  def update

    @project_type = ProjectType.find params[:id]

    if @project_type.update_attributes project_type_params
      flash[:notice] = 'Type item has been updated'
      redirect_to admin_project_type_path(@project_type)
    else
      flash.now[:warning] = 'There were problems when trying to update this Type item'
      render :action => :show
    end
  end

  def destroy
    @project_type = ProjectType.find params[:id]

    @project_type.destroy
    flash[:notice] = 'Type item has been deleted'
    redirect_to admin_project_type_path
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
