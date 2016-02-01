class AddRankToSection < ActiveRecord::Migration
  def change
    add_column :sections, :rank, :integer
  end
end
