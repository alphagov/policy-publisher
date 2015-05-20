class AddWorkingGroupContentIdsToPolicy < ActiveRecord::Migration
  def change
    add_column :policies, :working_group_content_ids, :text, array: true, default: []
  end
end
