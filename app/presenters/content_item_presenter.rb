require 'govspeak'

class ContentItemPresenter

  def initialize(policy)
    @policy = policy
  end

  def exportable_attributes
    {
      base_path: base_path,
      format: "policy",
      title: title,
      description: description,
      public_updated_at: public_updated_at,
      locale: "en",
      publishing_app: "policy-publisher",
      rendering_app: "finder-frontend",
      routes: routes,
      details: details,
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
      default_documents_per_page: 40,
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
        key: "detailed_format",
        name: "Document type",
        preposition: "of type",
        type: "text",
        display_as_result_metadata: false,
        filterable: true,
        allowed_values: detailed_format_allowed_values,
      },
      {
        key: "display_type",
        type: "text",
        display_as_result_metadata: true,
        filterable: false,
      },
      {
        key: "organisations",
        name: "Organisation",
        short_name: "From",
        preposition: "from",
        type: "text",
        display_as_result_metadata: true,
        filterable: true
      },
      {
        key: "people",
        name: "People",
        preposition: "from",
        type: "text",
        display_as_result_metadata: false,
        filterable: true
      },
      {
        key: "public_timestamp",
        short_name: "Updated",
        name: "Published",
        type: "date",
        display_as_result_metadata: true,
        filterable: true
      },
    ]
  end

  def detailed_format_allowed_values
    DETAILED_FORMAT_ALLOWED_VALUES
  end
end
