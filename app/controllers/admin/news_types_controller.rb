class Admin::NewsTypesController < AdminController

  def index
    @news_types = NewsType.where(nil)
    @news_types = @news_types
  end

  def show
    @news_type = NewsType.find params[:id]
  end

  def new
    @news_type = NewsType.new
  end

  def create
    @news_type = NewsType.new news_type_params

    if @news_type.save
      flash[:notice] = 'Type item created'
      redirect_to admin_news_types_path
    else
      flash.now[:warning] = @news_type.errors.full_messages
      render :action => :new
    end
  end

  def update

    @news_type = NewsType.find params[:id]

    if @news_type.update news_type_params
      flash[:notice] = 'Type item has been updated'
      redirect_to admin_news_type_path(@news_type)
    else
      flash.now[:warning] = @news_type.errors.full_messages
      render :action => :show
    end
  end

  def destroy
    @news_type = NewsType.find params[:id]
    @news_type.destroy
    flash[:notice] = 'Type item has been deleted'
    redirect_to admin_news_types_path
  end

  def rank
    pp = params[:news_types]
    NewsType.update(pp.keys, pp.values)
    flash[:notice] = 'Type items have been updated'
    redirect_to admin_news_types_path
  end

  private

  def news_type_params
    params.require(:news_type).permit(
      :title,
      :section_id,
      :parent_id,
      :rank
    )
  end
end
