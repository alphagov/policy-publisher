class Policy < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation on: :create do |policy|
    policy.slug = policy.name.to_s.parameterize
  end
end
