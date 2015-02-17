class ContentItemPresenter

  def initialize(policy)
    @policy = policy
  end

  def exportable_attributes
    {
      "base_path" => base_path,
      "format" => "policy_area",
      "content_id" => content_id,
      "title" => title,
      "description" => description,
      "public_updated_at" => public_updated_at,
      "update_type" => "major",
      "publishing_app" => "policy-publisher",
      "rendering_app" => "finder-frontend",
      "routes" => routes,
      "details" => details,
      "links" => {
        "organisations" => [],
        "topics" => [],
        "related" => [],
        "part_of" => [],
      },
    }
  end

private
  attr_reader :policy

  def base_path
    "/government/policies/#{policy.slug}"
  end

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
      }
    ]
  end

  def details
    {
      document_noun: "areas",
      email_signup_enabled: false,
      filter: {
        policies: [policy.slug]
      },
      human_readable_finder_format: human_readable_finder_format,
      signup_link: nil,
      summary: policy.description,
      show_summaries: false,
      facets: [],
    }
  end

  def human_readable_finder_format
    case policy
    when PolicyArea
      "Policy area"
    when Programme
      "Policy programme"
    end
  end
end
