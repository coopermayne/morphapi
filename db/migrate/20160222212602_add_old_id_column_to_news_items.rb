class AddOldIdColumnToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :old_id, :integer
  end
end
