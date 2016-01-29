class AddPersonRefToEducation < ActiveRecord::Migration
  def change
    add_reference :educations, :person, index: true, foreign_key: true
  end
end
