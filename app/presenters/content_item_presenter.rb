class ContentItemPresenter

  def initialize(policy, update_type='major')
    @policy = policy
    @update_type = update_type
  end

  def exportable_attributes
    {
      "format" => "policy",
      "content_id" => content_id,
      "title" => title,
      "description" => description,
      "public_updated_at" => public_updated_at,
      "locale" => "en",
      "update_type" => update_type,
      "publishing_app" => "policy-publisher",
      "rendering_app" => "finder-frontend",
      "routes" => routes,
      "details" => details,
      "links" => {
        "organisations" => organisation_content_ids,
        "people" => people_content_ids,
        "related" => related,
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
      email_signup_enabled: false,
      filter: {
        policies: [policy.slug]
      },
      human_readable_finder_format: 'Policy',
      signup_link: '',
      summary: policy.description,
      show_summaries: false,
      facets: [],
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
end
