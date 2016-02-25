class Admin::UploadsController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    @title = "Files"
    @uploads = Upload.where(:uploadable => nil)

    #if @types.include? params[:type]
      #@type = params[:type]
      #@people = @people.where(params[:type]=> true)
    #end

    @uploads = @uploads.order(sort_column + " " + sort_direction).paginate :page => params[:page]
  end

  def show
    @title = 'View upload'
    @upload = Upload.find params[:id]
  end

  def new
    @project = Project.first

    @title = 'Add a new upload'
    @uploadable_models = [[  "Award", 0],[   "BibliographyItem", 1 ],[   "NewsItem", 2 ],[    "Person", 3 ],[   "Project", 4 ]]
    @upload = Upload.new
  end

  def create
    @upload = Upload.new upload_params

    if @upload.save
      flash[:notice] = 'Upload created'
      redirect_to admin_uploads_path
    else
      flash.now[:warning] = 'There were problems when trying to create a new upload'
      render :action => :new
    end
  end

  def update
    @casein_page_title = 'Update upload'

    @upload = Upload.find params[:id]

    if @upload.update_attributes upload_params
      flash[:notice] = 'Upload has been updated'
      redirect_to casein_people_path
    else
      flash.now[:warning] = 'There were problems when trying to update this upload'
      render :action => :show
    end
  end

  def destroy
    @upload = Upload.find params[:id]

    @upload.destroy
    flash[:notice] = 'Upload has been deleted'
    redirect_to casein_people_path
  end

  private

  def upload_params
    params.require(:upload).permit(:title, :name, :copyright, :rank, :file_type_id, :credit_id, :uploadable_id, :uploadable_type, :in_gallery)
  end

  def sort_column
    Upload.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
