class NewsItemsController < ApplicationController

  def index
    @news_items = NewsItem.includes(:news_type, :primary_image).order(created_at: :desc).limit(30)
  end

  def show
    @news_item = NewsItem.find(params[:id])
  end

end
