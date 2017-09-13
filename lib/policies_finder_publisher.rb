require "gds_api/publishing_api"

# This is a utility class for publishing the base-finder for policies to the
# publishing API. This finder lives at /government/policies.
#
# A rake task exists to (re-)publish this to Publishing API:
#
#   bundle exec rake publish_policies_finder
#
class PoliciesFinderPublisher
  CONTENT_ID = "d6582d48-df19-46b3-bf84-9157192801a6".freeze

  def publish
    Services.publishing_api.put_content(CONTENT_ID, exportable_attributes)
    Services.publishing_api.publish(CONTENT_ID)
  end

  def exportable_attributes
    {
      "base_path" => base_path,
      "document_type" => "finder",
      "schema_name" => "finder",
      "title" => "Policies",
      "description" => "",
      "public_updated_at" => public_updated_at,
      "locale" => "en",
      "publishing_app" => "policy-publisher",
      "rendering_app" => "finder-frontend",
      "routes" => routes,
      "details" => details,
      "update_type" => "major",
    }
  end

private

  def base_path
    "/government/policies"
  end

  def public_updated_at
    File.mtime(File.dirname(__FILE__))
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
      document_noun: "policy",
      default_order: "title",
      filter: {
        document_type: "policy"
      },
      summary: "Search for information about government policy or filter by department.",
      show_summaries: false,
      facets: facets,
    }
  end

  def facets
    [
      {
        key: "organisations",
        short_name: "From",
        type: "text",
        display_as_result_metadata: true,
        filterable: true,
        preposition: "from",
        name: "Organisation",
        # finder-frontend will fetch the `allowed_values` for this from rummager.
      },
    ]
  end
end
