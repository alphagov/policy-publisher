class DefaultEmptyArrayFields < ActiveRecord::Migration
  def change
    change_column :policies, :organisation_content_ids, :text, array: true, default: []
    change_column :policies, :people_content_ids, :text, array: true, default: []

    Policy.where(organisation_content_ids: nil).update_all(organisation_content_ids: [])
    Policy.where(people_content_ids: nil).update_all(people_content_ids: [])
  end
end
