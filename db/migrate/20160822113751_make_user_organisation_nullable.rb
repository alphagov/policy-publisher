class MakeUserOrganisationNullable < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :organisation_content_id, :string, default: nil, null: true
    end
  end

  def down
    change_table :users do |t|
      t.change :organisation_content_id, :string, default: "", null: false
    end
  end
end
