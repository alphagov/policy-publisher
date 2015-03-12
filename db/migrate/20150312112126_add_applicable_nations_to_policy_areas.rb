class AddApplicableNationsToPolicyAreas < ActiveRecord::Migration
  def change
    add_column :policy_areas, :england, :boolean, default: true
    add_column :policy_areas, :england_policy_url, :string
    add_column :policy_areas, :northern_ireland, :boolean, default: true
    add_column :policy_areas, :northern_ireland_policy_url, :string
    add_column :policy_areas, :scotland, :boolean, default: true
    add_column :policy_areas, :scotland_policy_url, :string
    add_column :policy_areas, :wales, :boolean, default: true
    add_column :policy_areas, :wales_policy_url, :string
  end
end
