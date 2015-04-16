class AddIndexToPolicies < ActiveRecord::Migration
  def change
    add_index :policies, :name
  end
end
