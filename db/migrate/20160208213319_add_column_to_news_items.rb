class AddColumnToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :in_news_box, :boolean, default: false
  end
end
