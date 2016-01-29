class AddPersonRefToRoles < ActiveRecord::Migration
  def change
    add_reference :roles, :person, index: true, foreign_key: true
  end
end
