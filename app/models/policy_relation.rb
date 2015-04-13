class PolicyRelation < ActiveRecord::Base
  belongs_to :policy
  belongs_to :related_policy, class_name: 'Policy'
end
