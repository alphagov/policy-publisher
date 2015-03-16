class AddPeopleIdsToPolicies < ActiveRecord::Migration
  def change
    add_column :policy_areas, :people_content_ids, :text, array: true
    add_column :programmes, :people_content_ids, :text, array: true
  end
end
