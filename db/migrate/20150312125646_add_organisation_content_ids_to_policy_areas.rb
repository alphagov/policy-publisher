class AddOrganisationContentIdsToPolicyAreas < ActiveRecord::Migration
  def change
    add_column :policy_areas, :organisation_content_ids, :text, array: true
  end
end
