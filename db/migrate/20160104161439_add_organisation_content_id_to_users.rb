class AddOrganisationContentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :organisation_content_id, :string, null: false, default: ''
  end
end
