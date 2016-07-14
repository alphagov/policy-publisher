class EmailAlertSignupContentItemPresenter

  def initialize(policy)
    @policy = policy
  end

  def exportable_attributes
    {
      base_path: base_path,
      document_type: "email_alert_signup",
      schema_name: "email_alert_signup",
      title: policy.name,
      description: "",
      public_updated_at: public_updated_at,
      locale: "en",
      publishing_app: "policy-publisher",
      rendering_app: "email-alert-frontend",
      routes: routes,
      details: details,
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
      email_alert_type: "policies",
      breadcrumbs: breadcrumbs,
      summary: summary,
      subscriber_list: {
        tags: {
          policies: [policy.slug],
        }
      },
      govdelivery_title: "#{policy.name} policy",
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
