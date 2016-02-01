class AddPrimaryImageToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :primary_id, :integer
  end
end
