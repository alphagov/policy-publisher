class AddOrganisationContentIdsToProgrammes < ActiveRecord::Migration
  def change
    add_column :programmes, :organisation_content_ids, :text, array: true
  end
end
