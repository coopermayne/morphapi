# == Schema Information
#
# Table name: news_items
#
#  id             :integer          not null, primary key
#  title          :string
#  description    :text
#  overview       :text
#  hit            :integer
#  place_name     :string
#  street_address :string
#  country        :string
#  city           :string
#  state          :string
#  zip            :integer
#  start_date     :date
#  end_date       :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  news_type_id   :integer
#  primary_id     :integer
#  in_news_box    :boolean          default(FALSE)
#

class NewsItemsController < ApplicationController

  def index
    page = params[:p] #(nil or a number)
    type = params[:q] #(books/bibliography/videos)
    sorting = params[:sub] #(pub_date)/(title)

    #set page vars
    per_page = 30
    starting_page = page ? 30*page.to_i : 0

    @news_items = NewsItem.includes(:news_type, :primary_image).order(created_at: :desc)
    @total_pages = ( @news_items.count/30 ).ceil

    @current_page = page || 0
    @news_items = @news_items.slice(starting_page, per_page)
  end

  def show
    @news_item = NewsItem.find(params[:id])
  end

end
