# Republishes all a policies parent policies to the Publishing API
class ParentPolicyContentItemRepublisher
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def run!
    policy.parent_policies.each do |parent_policy|
      ContentItemRepublisher.new(parent_policy).run!
    end
  end
end
