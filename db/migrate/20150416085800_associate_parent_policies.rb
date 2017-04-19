class AssociateParentPolicies < ActiveRecord::Migration
  POLICY_PARENT_MAPPINGS = {
    'automatic-enrolment-in-workplace-pensions' => ['employment', 'older-people'],
    'city-deal' => ['localism'],
    'regional-growth-fund' => ['employment'],
    'hs2-high-speed-rail' => ['rail-network']
  }.freeze

  def change
    POLICY_PARENT_MAPPINGS.each do |policy_slug, parent_policy_slugs|
      policy = Policy.find_by!(slug: policy_slug)
      parents = Policy.where(slug: parent_policy_slugs)
      policy.parent_policies = parents
    end
  end
end
