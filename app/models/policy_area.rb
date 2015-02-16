class PolicyArea < ActiveRecord::Base
  include Publishable

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation on: :create do |policy_area|
    policy_area.slug = policy_area.name.to_s.parameterize
  end
end
