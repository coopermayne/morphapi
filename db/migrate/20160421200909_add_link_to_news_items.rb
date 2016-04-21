class AddLinkToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :link, :string
  end
end
