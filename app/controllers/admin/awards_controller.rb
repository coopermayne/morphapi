class Admin::AwardsController < AdminController

  def index
    @title = "Awards"
    @awards = Award.where(nil)
    @awards = @awards.order(created_at: :desc)
  end

  def show
    @title = "Edit Award"
    @award = Award.find params[:id]
  end

  def new
    @title = "New Award"
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
      redirect_to admin_award_path(@award)
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
      { :project_ids => [] },
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
end
