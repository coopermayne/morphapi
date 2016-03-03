class AddUIdAndSectionToSearchResults < ActiveRecord::Migration
  def change
    add_column :search_results, :uid, :string
    add_column :search_results, :section, :string
  end
end
