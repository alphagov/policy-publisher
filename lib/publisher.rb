# Publisher for publishing polices onto GOV.UK
class Publisher
  attr_reader :policy
  def initialize(policy)
    @policy = policy
  end

  def publish!
    publish_to_publishing_api!
    add_to_search_index!
    republish_parents_to_publishing_api! if programme?
  end

private

  def programme?
    policy.programme?
  end

  def publish_to_publishing_api!
    payload = ContentItemPresenter.new(policy).exportable_attributes
    publishing_api.put_content_item(policy.base_path, payload)
  end

  def republish_parents_to_publishing_api!
    policy.parent_policies.each do |parent_policy|
      republish_to_publishing_api!(parent_policy)
    end
  end

  def republish_to_publishing_api!(republishing_policy)
    payload = ContentItemPresenter.new(republishing_policy, "minor").exportable_attributes
    publishing_api.put_content_item(republishing_policy.base_path, payload)
  end

  def add_to_search_index!
    SearchIndexer.new(policy).index!
  end

  def publishing_api
    @publishing_api ||= PolicyPublisher.services(:publishing_api)
  end
end
