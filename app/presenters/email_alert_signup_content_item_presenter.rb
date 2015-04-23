class EmailAlertSignupContentItemPresenter

  def initialize(policy, update_type="major")
    @policy = policy
    @update_type = update_type
  end

  def exportable_attributes
    {
      format: "email_alert_signup",
      content_id: policy.email_alert_signup_content_id,
      title: policy.name,
      description: "",
      public_updated_at: public_updated_at,
      locale: "en",
      update_type: update_type,
      publishing_app: "policy-publisher",
      rendering_app: "email-alert-frontend",
      routes: routes,
      details: details,
      links: {},
    }
  end

  def base_path
    "#{policy.base_path}/email-signup"
  end

private
  attr_reader :policy, :update_type

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
      breadcrumbs: breadcrumbs,
      summary: summary,
      tags: {
        policy: [policy.slug],
      },
    }
  end

  def summary
    %q[
      You'll get an email each time a document about
      this policy is published or updated.
    ]
  end

  def breadcrumbs
    [
      {
        title: policy.name,
        link: policy.base_path,
      }
    ]
  end

end
