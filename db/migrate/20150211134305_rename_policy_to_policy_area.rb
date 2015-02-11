class RenamePolicyToPolicyArea < ActiveRecord::Migration
  def change
    rename_table :policies, :policy_areas
  end
end
