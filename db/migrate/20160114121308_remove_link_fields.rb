class RemoveLinkFields < ActiveRecord::Migration
  def up
    change_table :policies do |t|
      t.remove :organisation_content_ids
      t.remove :people_content_ids
      t.remove :working_group_content_ids
    end
  end

  def down
    change_table :policies do |t|
      t.text    :organisation_content_ids, array: true, default: []
      t.text    :people_content_ids, array: true, default: []
      t.text    :working_group_content_ids, array: true, default: []
    end
  end

end
