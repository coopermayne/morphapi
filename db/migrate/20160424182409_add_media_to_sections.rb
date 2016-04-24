class AddMediaToSections < ActiveRecord::Migration
  def change
    add_column :sections, :media, :text
  end
end
