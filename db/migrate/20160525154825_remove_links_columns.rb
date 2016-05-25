class RemoveLinksColumns < ActiveRecord::Migration
  def change
    remove_column :policies, :working_group_content_ids
    remove_column :policies, :people_content_ids
  end
end
