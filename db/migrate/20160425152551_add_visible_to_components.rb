class AddVisibleToComponents < ActiveRecord::Migration
  def change
    add_column :components, :id_visibile, :boolean, default: false
  end
end
