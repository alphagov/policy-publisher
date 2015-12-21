# Publishes a policy content item to the Publishing API
class ContentItemPublisher
  attr_reader :policy, :update_type

  def initialize(policy, update_type: "major")
    @policy = policy
    @update_type = update_type
  end

  def run!
    InstantPublisher.publish(
      content_id: policy.content_id,
      content_payload: content_payload,
      links_payload: links_payload,
      update_type: update_type,
    )
  end

  def content_payload
    ContentItemPresenter.new(policy).exportable_attributes
  end

  def links_payload
    LinksPresenter.new(policy).exportable_attributes
  end
end
