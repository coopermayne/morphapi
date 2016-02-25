class Admin::PeopleController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    @people = Person.where(nil)
    @types = ["is_morphosis", "is_employed", "is_collaborator", "is_consultant"]

    if @types.include? params[:type]
      @type = params[:type]
      @people = @people.where(params[:type]=> true)
    end

    @people = @people.order(sort_column + " " + sort_direction).paginate :page => params[:page]
  end

  def show
    @casein_page_title = 'View person'
    @person = Person.find params[:id]
  end

  def new
    @casein_page_title = 'Add a new person'
    @person = Person.new
  end

  def create
    @person = Person.new person_params

    if @person.save
      flash[:notice] = 'Person created'
      redirect_to casein_people_path
    else
      flash.now[:warning] = 'There were problems when trying to create a new person'
      render :action => :new
    end
  end

  def update
    @casein_page_title = 'Update person'

    @person = Person.find params[:id]

    if @person.update_attributes person_params
      flash[:notice] = 'Person has been updated'
      redirect_to casein_people_path
    else
      flash.now[:warning] = 'There were problems when trying to update this person'
      render :action => :show
    end
  end

  def destroy
    @person = Person.find params[:id]

    @person.destroy
    flash[:notice] = 'Person has been deleted'
    redirect_to casein_people_path
  end

  private

  def person_params
    params.require(:person).permit(
      :name,
      :birthday,
      :description,
      :email,
      :is_morphosis,
      :is_employed,
      :is_collaborator, 
      :is_consultant, 
      :start_date,
      :end_date,
      :website, 
      :location,
      uploads_attributes: [
        :id,
        :_destroy,
        :file_type_id,
        :rank,
        :in_gallery,
        :title,
        :name,
        :credit_id,
        :copyright
      ]

    )
  end

  def sort_column
    Person.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
