class PolicyAreaContentItemPresenter

  def initialize(policy_area)
    @policy_area = policy_area
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
  attr_reader :policy_area

  def base_path
    "/government/policies/#{policy_area.slug}"
  end

  def content_id
    policy_area.content_id
  end

  def title
    policy_area.name
  end

  def description
    ""
  end

  def public_updated_at
    policy_area.updated_at
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
        policies: [policy_area.slug]
      },
      signup_link: nil,
      summary: policy_area.description,
      show_summaries: false,
      facets: [],
    }
  end
end
