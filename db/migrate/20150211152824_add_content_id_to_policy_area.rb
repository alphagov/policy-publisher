class AddContentIdToPolicyArea < ActiveRecord::Migration
  def change
    add_column :policy_areas, :content_id, :string
    add_index :policy_areas, :content_id, unique: true
  end
end
