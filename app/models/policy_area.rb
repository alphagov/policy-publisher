require 'gds_api/publishing_api'

class PolicyArea < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :content_id, presence: true, uniqueness: true

  before_validation on: :create do |policy_area|
    policy_area.slug = policy_area.name.to_s.parameterize
    policy_area.content_id = SecureRandom.uuid
  end

  after_save :publish_policy_area_finder

private
  def publish_policy_area_finder
    attrs = PolicyAreaContentItemPresenter.new(self).exportable_attributes
    publishing_api.put_content_item(attrs["base_path"], attrs)
  end

  def publishing_api
    @publishing_api || PolicyPublisher.services(:publishing_api)
  end
end
