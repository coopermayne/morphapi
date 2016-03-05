class Admin::BibliographyItemsController < AdminController

  def index
    @title = "Bibliography Items"
    @bibliography_items = BibliographyItem.where(nil)
    @bibliography_items = @bibliography_items.order(created_at: :desc)

  end

  def show
    @title = "Edit Bib"
    @bibliography_item = BibliographyItem.find params[:id]
  end

  def new
    @title = "New Bib"
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
      redirect_to admin_bibliography_item_path(@bibliography_item)
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
      :author,
      :article_name,
      :book_title,
      :subtitle,
      :publication,
      :publisher,
      :date,
      :pub_date,
      :pages,
      :description,
      :overview,
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
        :make_primary, 
        :make_index,
        :copyright
      ],
    )
  end

end
