class RemoveParentRefFromSections < ActiveRecord::Migration
  def change
    remove_reference :sections, :parent, index: true
  end
end
