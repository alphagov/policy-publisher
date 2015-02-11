class PolicyArea < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :content_id, presence: true, uniqueness: true

  before_validation on: :create do |policy_area|
    policy_area.slug = policy_area.name.to_s.parameterize
    policy_area.content_id = SecureRandom.uuid
  end
end
