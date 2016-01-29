class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :last_name
      t.date :birthday
      t.string :bio
      t.string :email
      t.string :education

      t.timestamps null: false
    end
  end
end
