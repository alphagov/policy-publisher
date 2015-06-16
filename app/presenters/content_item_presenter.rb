require 'govspeak'

class ContentItemPresenter

  def initialize(policy, update_type='major')
    @policy = policy
    @update_type = update_type
  end

  def exportable_attributes
    {
      format: "policy",
      content_id: content_id,
      title: title,
      description: description,
      public_updated_at: public_updated_at,
      locale: "en",
      update_type: update_type,
      publishing_app: "policy-publisher",
      rendering_app: "finder-frontend",
      routes: routes,
      details: details,
      links: {
        organisations: organisation_content_ids,
        people: people_content_ids,
        working_groups: working_group_content_ids,
        related: related,
        email_alert_signup: email_alert_signup_content_id,
        policy_areas: policy_areas,
      },
    }
  end

  def base_path
    policy.base_path
  end

private
  attr_reader :policy, :update_type

  def content_id
    policy.content_id
  end

  def organisation_content_ids
    policy.organisation_content_ids || []
  end

  def people_content_ids
    policy.people_content_ids || []
  end

  def working_group_content_ids
    policy.working_group_content_ids
  end

  def email_alert_signup_content_id
    [policy.email_alert_signup_content_id]
  end

  def title
    policy.name
  end

  def description
    ""
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
      {
        path: "#{base_path}.json",
        type: "exact",
      },
      {
        path: "#{base_path}.atom",
        type: "exact",
      }
    ]
  end

  def details
    details = {
      document_noun: "document",
      filter: {
        policies: [policy.slug]
      },
      human_readable_finder_format: 'Policy',
      signup_link: '',
      summary: summary,
      show_summaries: false,
      facets: facets,
    }

    details.merge(nation_applicability)
  end

  def nation_applicability
    if inapplicable_nations.any?
      {
        nation_applicability: {
          applies_to: policy.applicable_nations,
          alternative_policies: alternative_policies,
        }
      }
    else
      {}
    end
  end

  def summary
    Govspeak::Document.new(policy.description).to_html
  end

  def alternative_policies
    inapplicable_nations_with_urls = inapplicable_nations.select { |nation|
      policy.send(:"#{nation}_policy_url").present?
    }
    inapplicable_nations_with_urls.map { |nation|
      {nation: nation, alt_policy_url: policy.send(:"#{nation}_policy_url")}
    }
  end

  def inapplicable_nations
    policy.possible_nations - policy.applicable_nations || []
  end

  def related
    policy.related_policies.map(&:content_id)
  end

  def policy_areas
    policy.parent_policies.map(&:content_id)
  end

  def facets
    [
      {
        key: "is_historic",
        display_as_result_metadata: true,
        filterable: false,
      },
      {
        key: "government_name",
        display_as_result_metadata: true,
        filterable: false,
      },
      {
        key: "public_timestamp",
        short_name: "Updated",
        name: "Published",
        type: "date",
        display_as_result_metadata: true,
        filterable: true
      },
      {
        key: "organisations",
        short_name: "From",
        type: "text",
        display_as_result_metadata: true,
        filterable: true
      },
      {
        key: "display_type",
        short_name: "Type",
        type: "text",
        display_as_result_metadata: true,
        filterable: false
      },
      {
        key: "people",
        name: "People",
        type: "text",
        display_as_result_metadata: false,
        filterable: true
      },
    ]
  end
end
