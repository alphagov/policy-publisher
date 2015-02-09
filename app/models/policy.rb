class Policy < ActiveRecord::Base
  before_create do |policy|
    policy.slug = policy.name.parameterize
  end
end
