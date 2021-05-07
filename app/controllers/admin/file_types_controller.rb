class Admin::FileTypesController < AdminController

  def index
    @file_types = FileType.where(nil)
    @file_types = @file_types
  end

  def show
    @file_type = FileType.find params[:id]
  end

  def new
    @file_type = FileType.new
  end

  def create
    @file_type = FileType.new file_type_params

    if @file_type.save
      flash[:notice] = 'Type item created'
      redirect_to admin_file_types_path
    else
      flash.now[:warning] = @file_type.errors.full_messages.to_s
      render :action => :new
    end
  end

  def update

    @file_type = FileType.find params[:id]

    if @file_type.update file_type_params
      flash[:notice] = 'Type item has been updated'
      redirect_to admin_file_type_path(@file_type)
    else
      flash.now[:warning] = @file_type.errors.full_messages.to_s
      render :action => :show
    end
  end

  def destroy
    @file_type = FileType.find params[:id]
    @file_type.destroy
    flash[:notice] = 'Type item has been deleted'
    redirect_to admin_file_types_path
  end

  def rank
    pp = params[:file_types]
    FileType.update(pp.keys, pp.values)
    flash[:notice] = 'Type items have been updated'
    redirect_to admin_file_types_path
  end

  private

  def file_type_params
    params.require(:file_type).permit(
      :title,
      :rank
    )
  end
end
