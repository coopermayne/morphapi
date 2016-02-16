class AddColumnToSearchResults < ActiveRecord::Migration
  def change
    add_column :search_results, :weight, :integer, default: 0
  end
end
