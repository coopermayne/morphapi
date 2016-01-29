class AddIsMorphosisAndIsCollaboratorAndIsConsultantAndIsEmployedToPerson < ActiveRecord::Migration
  def change
    add_column :people, :is_morphosis, :boolean
    add_column :people, :is_employed, :boolean
    add_column :people, :is_collaborator, :boolean
    add_column :people, :is_consultant, :boolean
  end
end
