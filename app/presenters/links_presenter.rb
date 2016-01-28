class LinksPresenter
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def exportable_attributes
    {
      links: {
        organisations: organisation_content_ids,
        lead_organisations: lead_organisation_content_ids,
        people: people_content_ids,
        working_groups: working_group_content_ids,
        related: related,
        email_alert_signup: email_alert_signup_content_id,
        policy_areas: policy_areas,
      }
    }
  end

private

  def organisation_content_ids
    policy.organisation_content_ids
  end

  def lead_organisation_content_ids
    policy.lead_organisation_content_ids
  end

  def people_content_ids
    policy.people_content_ids
  end

  def working_group_content_ids
    policy.working_group_content_ids
  end

  def email_alert_signup_content_id
    [policy.email_alert_signup_content_id]
  end

  def related
    policy.related_policies.map(&:content_id)
  end

  def policy_areas
    policy.parent_policies.map(&:content_id)
  end
end
