require "gds_api/publishing_api"

# This is a utility class for publishing the email alert signup page for policies
# to the publishing API. The signup page lives at /government/policy/policy-slug/email-signup
class PolicySignupPagePublisher

  def initialize(policy, update_type="major")
    @policy = policy
    @update_type = update_type
  end

  def publish
    publishing_api.put_content_item(base_path, exportable_attributes)
  end

  def exportable_attributes
    {
      format: "email_alert_signup",
      content_id: policy.email_alert_signup_content_id,
      title: policy.name,
      description: description,
      public_updated_at: policy.updated_at.iso8601,
      locale: "en",
      update_type: update_type,
      publishing_app: "policy-publisher",
      rendering_app: "email-alert-frontend",
      routes: routes,
      details: details,
      links: {
        organisations: [],
        related: [],
      },
    }
  end

private
  attr_reader :policy, :update_type

  def base_path
    "#{policy.base_path}/email-signup"
  end

  def public_updated_at
    policy.updated_at
  end

  def routes
    [
      {
        path: base_path,
        type: "exact",
      },
    ]
  end

  def details
    {
      breadcrumbs: [breadcrumbs],
      tags: {
        policy: [policy.slug],
      },
    }
  end

  def description
    %q[
      You'll get an email each time any information for
      this policy is published or updated.
    ]
  end

  def breadcrumbs
    {
      title: policy.name,
      link: policy.base_path,
    }
  end

  def publishing_api
    @publishing_api ||= PolicyPublisher.services(:publishing_api)
  end

end
