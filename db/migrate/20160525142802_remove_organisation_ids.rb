class RemoveOrganisationIds < ActiveRecord::Migration
  def change
    remove_column :policies, :organisation_content_ids
  end
end
