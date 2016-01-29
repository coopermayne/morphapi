class AddForeignKeysToComponents < ActiveRecord::Migration
  def change
    add_reference :components, :project, index: true
    add_reference :components, :component_type, index: true
  end
end
