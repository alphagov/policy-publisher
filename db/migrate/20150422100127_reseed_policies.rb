require 'csv'

class ReseedPolicies < ActiveRecord::Migration
POLICY_PARENT_MAPPINGS = {
    'automatic-enrolment-in-workplace-pensions' => ['employment', 'older-people'],
    'city-deal' => ['localism'],
    'regional-growth-fund' => ['employment'],
    'hs2-high-speed-rail' => ['rail-network']
  }

  def change
    Policy.destroy_all

    CSV.foreach(Rails.root.join('db/migrate/policies.csv'), headers: true) do |row|
      policy = create_policy!(row)
      # Forcably override the content_id to that in the seed data
      policy.update_column(:content_id, row['content_id'])
      Publisher.new(policy).publish!
    end

    POLICY_PARENT_MAPPINGS.each do |policy_slug, parent_policy_slugs|
      policy = Policy.find_by!(slug: policy_slug)
      parents = Policy.where(slug: parent_policy_slugs)
      policy.parent_policies = parents
    end
  end

private
  def create_policy!(row)
    puts %Q(Creating policy "#{row['name']}")
    Policy.create!(
      name: row['name'],
      description: row['description'],
      content_id: row['content_id'],
      organisation_content_ids: row['organisation_content_ids'].split('|')
    )
  end
end

