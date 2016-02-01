class AddPrimaryImageToPeople < ActiveRecord::Migration
  def change
    add_column :people, :primary_id, :integer
  end
end
