class Admin::PeopleController < AdminController
  def index
    @title = "People"
    @people = Person.where(nil)
    @types = ["is_morphosis", "is_employed", "is_collaborator", "is_consultant"]

    if @types.include? params[:type]
      @type = params[:type]
      @people = @people.where(params[:type]=> true)
    end

    @people = @people.order(created_at: :desc)
  end

  def show
    @title = 'Edit Person'
    @person = Person.find params[:id]
  end

  def new
    @title = 'New Person'
    @person = Person.new
  end

  def create
    @person = Person.new person_params

    if @person.save
      flash[:notice] = 'Person created'
      redirect_to admin_people_path
    else
      flash.now[:warning] = @person.errors.full_messages
      render :action => :new
    end
  end

  def update
    @title = 'Update person'

    @person = Person.find params[:id]

    if @person.update person_params
      flash[:notice] = 'Person has been updated'
      redirect_to admin_person_path(@person)
    else
      flash.now[:warning] = @person.errors.full_messages
      render :action => :show
    end
  end

  def destroy
    @person = Person.find params[:id]

    @person.destroy
    flash[:notice] = 'Person has been deleted'
    redirect_to admin_people_path
  end

  private

  def person_params
    params.require(:person).permit(
      :name,
      :last_name,
      :make_primary,
      :make_index,
      :birthday,
      :description,
      :email,
      :is_morphosis,
      :is_leadership,
      :is_associate,
      :is_employed,
      :is_collaborator, 
      :is_consultant, 
      :start_date,
      :end_date,
      :website, 
      :location,
      educations_attributes: [
        :id,
        :_destroy,
        :title
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
