class Admin::AwardsController < AdminController

  def index
    @awards = Award.all
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
end
