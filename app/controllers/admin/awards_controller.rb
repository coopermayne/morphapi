class Admin::AwardsController < AdminController
  helper_method :sort_column, :sort_direction

  def index

    @awards = Award.where(nil)
    @awards = @awards.order(sort_column+ " " + sort_direction).paginate :page => params[:page]

  end

  def show
    @award = Award.find params[:id]
  end

  def new
    @award = Award.new
  end

  def create
    @award = Award.new award_params

    if @award.save
      flash[:notice] = 'Award item created'
      redirect_to admin_awards_path
    else
      flash.now[:warning] = 'There were problems when trying to create a new Award item'
      render :action => :new
    end
  end

  def update

    @award = Award.find params[:id]

    if @award.update_attributes award_params
      flash[:notice] = 'Award item has been updated'
      redirect_to admin_awards_path
    else
      flash.now[:warning] = 'There were problems when trying to update this Award item'
      render :action => :show
    end
  end

  def destroy
    @award = Award.find params[:id]

    @award.destroy
    flash[:notice] = 'Award item has been deleted'
    redirect_to admin_awards_path
  end

  private

  def award_params
    params.require(:award).permit(
      :title,
      :description,
      :overview,
      :year,
      :projects_ids,
      :primary_id,
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
    Award.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
