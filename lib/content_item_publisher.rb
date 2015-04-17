class ContentItemPublisher
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def run!
    publishing_api.put_content_item(base_path, content_item_payload('major'))
  end

  def content_item_payload(update_type)
    ContentItemPresenter.new(policy, update_type).exportable_attributes
  end

private

  def base_path
    policy.base_path
  end

  def publishing_api
    @publishing_api ||= PolicyPublisher.services(:publishing_api)
  end
end
