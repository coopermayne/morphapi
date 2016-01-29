class ChangeColumnsInProject < ActiveRecord::Migration
  def change
    rename_column :projects, :close_edate, :close_date
    rename_column :projects, :open_sdate, :open_date
  end
end
