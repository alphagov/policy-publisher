class DropFeatureFlagsTable < ActiveRecord::Migration
  def change
    drop_table :feature_flags
  end
end
