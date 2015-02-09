class CreatePolicy < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.string :slug
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
