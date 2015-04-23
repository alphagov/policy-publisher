# Publishes an email alert signup content item to the Publishing API
class EmailAlertSignupContentItemPublisher
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def run!
    publishing_api.put_content_item(content_item_payload.base_path, content_item_payload.exportable_attributes)
  end

  def content_item_payload
    EmailAlertSignupContentItemPresenter.new(policy, 'major')
  end

private

  def publishing_api
    @publishing_api ||= PolicyPublisher.services(:publishing_api)
  end
end
