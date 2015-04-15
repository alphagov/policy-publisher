class CreatePolicyRelations < ActiveRecord::Migration
  def change
    create_table :policy_relations do |t|
      t.references :policy
      t.references :related_policy
      t.timestamps null: false
    end

    add_index :policy_relations, :policy_id
    add_index :policy_relations, :related_policy_id
  end
end
