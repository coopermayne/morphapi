class AddColumnsToSearchResults < ActiveRecord::Migration
  def change
    add_column :search_results, :thumb, :string
    add_column :search_results, :description, :string
  end
end
