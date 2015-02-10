class MakePolicyNameUnique < ActiveRecord::Migration
  def change
    add_index :policies, :name, unique: true
  end
end
