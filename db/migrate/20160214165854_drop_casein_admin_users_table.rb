class DropCaseinAdminUsersTable < ActiveRecord::Migration
  def up
    drop_table :casein_admin_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
