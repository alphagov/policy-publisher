class CreateProgramme < ActiveRecord::Migration
  def change
    create_table :programmes do |t|
      t.string   "slug"
      t.string   "name"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "programmes", ["name"], unique: true
    add_index "programmes", ["slug"], unique: true
  end
end
