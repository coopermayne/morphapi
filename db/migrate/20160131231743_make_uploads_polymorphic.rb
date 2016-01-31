class MakeUploadsPolymorphic < ActiveRecord::Migration
  def change
    remove_reference :uploads, :project, index: true
    remove_reference :uploads, :person, index: true
    remove_reference :uploads, :new_item, index: true
  end
end
