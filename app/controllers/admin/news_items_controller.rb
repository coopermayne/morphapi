class Admin::NewsItemsController < AdminController
  def index
    @title="News Items"
    @news_type_id = params[:type]
    @news_items = NewsItem.where(nil)
    @news_items = @news_items.where(news_type_id: @news_type_id) if @news_type_id
    @news_items = @news_items.order(created_at: :desc)
  end

  def show
    @title = "Edit News Item"
    @news_item = NewsItem.find params[:id]
  end

  def new
    @title = "New News Item"
    @news_item = NewsItem.new
  end

  def create
    @news_item = NewsItem.new news_item_params

    if @news_item.save
      flash[:notice] = 'News item created'
      redirect_to admin_news_items_path
    else
      flash.now[:warning] = 'There were problems when trying to create a new news item'
      render :action => :new
    end
  end

  def update

    @news_item = NewsItem.find params[:id]

    if @news_item.update_attributes news_item_params
      flash[:notice] = 'News item has been updated'
      redirect_to admin_news_item_path(@news_item)
    else
      flash.now[:warning] = 'There were problems when trying to update this news item'
      render :action => :show
    end
  end

  def destroy
    @news_item = NewsItem.find params[:id]

    @news_item.destroy
    flash[:notice] = 'News item has been deleted'
    redirect_to admin_news_items_path
  end

  private

  def news_item_params
    params.require(:news_item).permit(
      :title,
      :description,
      :overview,
      :place_name,
      :street_address,
      :address,
      :city,
      :state,
      :country,
      :zip,
      :start_date,
      :news_type_id,
      :in_news_box,
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
