require 'csv'

class ImportPolicies < ActiveRecord::Migration
  def up
    CSV.foreach(Rails.root.join('db/migrate/policies.csv'), headers: true) do |row|
      policy = create_policy!(row)
      Publisher.new(policy).publish!
    end
  end

  def down
    Policy.destroy_all
  end

private

  def create_policy!(row)
    puts %(Creating policy "#{row['name']}")
    Policy.create!(
      name: row['name'],
      description: row['description'],
      content_id: row['content_id'],
      organisation_content_ids: row['organisation_content_ids'].split('|')
    )
  end
end
