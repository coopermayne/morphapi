class AddIsAssociateToPeople < ActiveRecord::Migration
  def change
    add_column :people, :is_associate, :boolean, default: false
  end
end
