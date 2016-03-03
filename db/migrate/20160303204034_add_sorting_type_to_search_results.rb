class AddSortingTypeToSearchResults < ActiveRecord::Migration
  def change
    add_column :search_results, :sorting_type, :string
  end
end
