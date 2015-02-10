class Policy < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  before_create do |policy|
    policy.slug = policy.name.parameterize
  end
end
