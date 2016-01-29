class AddForeignKeysToUpload < ActiveRecord::Migration
  def change
    add_reference :uploads, :project, index: true
    add_reference :uploads, :person, index: true
    add_reference :uploads, :new_item, index: true
  end
end
