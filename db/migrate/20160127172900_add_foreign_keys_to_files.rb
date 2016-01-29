class AddForeignKeysToFiles < ActiveRecord::Migration
  def change
    add_reference :uploads, :file_type, index: true
    add_reference :uploads, :credit, index: true
  end
end
