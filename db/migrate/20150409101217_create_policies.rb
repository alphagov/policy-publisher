class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.string  :slug
      t.string  :name
      t.text    :description
      t.string  :content_id
      t.text    :organisation_content_ids, array: true
      t.text    :people_content_ids,       array: true
      t.boolean :england, default: true
      t.string  :england_policy_url
      t.boolean :northern_ireland, default: true
      t.string  :northern_ireland_policy_url
      t.boolean :scotland, default: true
      t.string  :scotland_policy_url
      t.boolean :wales, default: true
      t.string  :wales_policy_url

      t.timestamps null: false
    end
  end
end
