class CreatePolicyAreaProgrammeJoinTable < ActiveRecord::Migration
  def change
    create_table :policy_areas_programmes do |t|
      t.references :policy_area
      t.references :programme
      t.timestamps
    end
  end
end
