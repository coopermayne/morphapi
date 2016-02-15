class Admin::BibliographyItemsController < AdminController
  helper_method :sort_column, :sort_direction

  def index

    @bibliography_items = BibliographyItem.where(nil)
    @bibliography_items = @bibliography_items.order(sort_column+ " " + sort_direction).paginate :page => params[:page]

  end

  def show
    @bibliography_item = BibliographyItem.find params[:id]
  end

  def new
    @bibliography_item = BibliographyItem.new
  end

  def create
    @bibliography_item = BibliographyItem.new bibliography_item_params

    if @bibliography_item.save
      flash[:notice] = 'Bibliography item created'
      redirect_to admin_bibliography_items_path
    else
      flash.now[:warning] = 'There were problems when trying to create a new Bib item'
      render :action => :new
    end
  end

  def update

    @bibliography_item = BibliographyItem.find params[:id]

    if @bibliography_item.update_attributes bibliography_item_params
      flash[:notice] = 'BibliographyItem item has been updated'
      redirect_to admin_bibliography_items_path
    else
      flash.now[:warning] = 'There were problems when trying to update this BibliographyItem item'
      render :action => :show
    end
  end

  def destroy
    @bibliography_item = BibliographyItem.find params[:id]

    @bibliography_item.destroy
    flash[:notice] = 'BibliographyItem item has been deleted'
    redirect_to admin_bibliography_items_path
  end

  private

  def bibliography_item_params
    params.require(:bibliography_item).permit(
      :title,
      :description,
      :overview,
      :projects_ids,
      :primary_id
    )
  end


  def sort_column
    BibliographyItem.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
