class AddApplicableNationsToProgrammes < ActiveRecord::Migration
  def change
    add_column :programmes, :england, :boolean, default: true
    add_column :programmes, :england_policy_url, :string
    add_column :programmes, :northern_ireland, :boolean, default: true
    add_column :programmes, :northern_ireland_policy_url, :string
    add_column :programmes, :scotland, :boolean, default: true
    add_column :programmes, :scotland_policy_url, :string
    add_column :programmes, :wales, :boolean, default: true
    add_column :programmes, :wales_policy_url, :string
  end
end
