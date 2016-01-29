class AddPositionRefToRoles < ActiveRecord::Migration
  def change
    add_reference :roles, :position, index: true, foreign_key: true
  end
end
