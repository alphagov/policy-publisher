require 'csv'

class ImportGroupsForPolicies < ActiveRecord::Migration
  def up
    csv_path = File.join(File.dirname(__FILE__), "20150520142917_import_groups_for_policies.csv")
    CSV.foreach(csv_path, headers: true) do |row|
      policy = Policy.find_by(content_id: row["policy_content_id"])
      puts "Adding group ##{row["group_content_id"]} to policy '#{policy.name}'"
      policy.working_group_content_ids << row["group_content_id"]
      policy.working_group_content_ids.uniq!
      policy.save!
    end
  end
end
