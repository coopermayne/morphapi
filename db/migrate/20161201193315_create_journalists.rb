class CreateJournalists < ActiveRecord::Migration
  def change
    create_table :journalists do |t|
      t.string :email

      t.timestamps null: false
    end
  end
end
