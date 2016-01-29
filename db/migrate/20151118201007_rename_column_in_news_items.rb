class RenameColumnInNewsItems < ActiveRecord::Migration
  def change
    rename_column :news_items, :place, :place_name
  end
end
