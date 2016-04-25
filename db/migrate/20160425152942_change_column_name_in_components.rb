class ChangeColumnNameInComponents < ActiveRecord::Migration
  def change
    rename_column :components, :id_visibile, :is_visible
  end
end
