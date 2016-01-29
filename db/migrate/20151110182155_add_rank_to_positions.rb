class AddRankToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :rank, :integer
  end
end
