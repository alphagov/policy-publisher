# Republishes all a policies parent policies to the Publishing API
class ParentPolicyContentItemRepublisher
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def run!
    policy.parent_policies.each do |parent_policy|
      ContentItemPublisher.new(parent_policy, update_type: "minor").run!
    end
  end
end
