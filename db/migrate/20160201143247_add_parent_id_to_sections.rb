class AddParentIdToSections < ActiveRecord::Migration
  def change
    add_reference :sections, :parent, index: true
  end
end
