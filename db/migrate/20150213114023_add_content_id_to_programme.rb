class AddContentIdToProgramme < ActiveRecord::Migration
  def change
    add_column :programmes, :content_id, :string
    add_index :programmes, :content_id, unique: true
  end
end
