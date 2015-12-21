# Publishes an email alert signup content item to the Publishing API
class EmailAlertSignupContentItemPublisher
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def run!
    InstantPublisher.publish(
      content_id: policy.email_alert_signup_content_id,
      content_payload: content_payload,
      links_payload: links_payload,
      update_type: 'major',
    )
  end

  def content_payload
    EmailAlertSignupContentItemPresenter.new(policy).exportable_attributes
  end

  def links_payload
    {
      links: { parent: [policy.content_id] }
    }
  end
end
