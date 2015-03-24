class ContentItemPresenter

  def initialize(policy)
    @policy = policy
  end

  def exportable_attributes
    {
      "format" => "policy",
      "content_id" => content_id,
      "title" => title,
      "description" => description,
      "public_updated_at" => public_updated_at,
      "locale" => "en",
      "update_type" => "major",
      "publishing_app" => "policy-publisher",
      "rendering_app" => "finder-frontend",
      "routes" => routes,
      "details" => details,
      "links" => {
        "organisations" => organisation_content_ids,
        "people" => people_content_ids,
        "related" => [],
      },
    }
  end

  def base_path
    policy.base_path
  end

private
  attr_reader :policy

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
    {
      document_noun: "document",
      email_signup_enabled: false,
      filter: {
        policies: [policy.content_id]
      },
      human_readable_finder_format: 'Policy',
      signup_link: '',
      summary: policy.description,
      show_summaries: false,
      facets: [],
    }
  end
end
