class PolicyRelation < ActiveRecord::Base
  belongs_to :policy
  belongs_to :related_policy, class_name: 'Policy'

  validate :not_self_referential

private

  def not_self_referential
    if policy_id == related_policy_id
      errors.add(:base, 'cannot be related to itself')
    end
  end
end
