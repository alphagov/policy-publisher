class DropRedundantTables < ActiveRecord::Migration
  def change
    drop_table :policy_areas
    drop_table :programmes
    drop_table :policy_areas_programmes
  end
end
