class MakePolicySlugUnique < ActiveRecord::Migration
  def change
    add_index :policies, :slug, unique: true
  end
end
