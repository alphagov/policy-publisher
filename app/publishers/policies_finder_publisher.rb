require "gds_api/publishing_api"

# This is a utility class for publishing the base-finder for policies to the
# publishing API. This finder lives at /government/policies.
#
# A rake task exists to (re-)publish this to Publishing API:
#
#   bundle exec rake publish_policies_finder
#
class PoliciesFinderPublisher

  def publish
    publishing_api.put_content_item(base_path, exportable_attributes)
  end

  def exportable_attributes
    {
      format: "finder",
      content_id: "d6582d48-df19-46b3-bf84-9157192801a6",
      title: "Policies",
      description: "",
      public_updated_at: public_updated_at.iso8601,
      locale: "en",
      update_type: "major",
      publishing_app: "policy-publisher",
      rendering_app: "finder-frontend",
      routes: routes,
      details: details,
      links: {
        organisations: [],
        related: [],
      },
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
      },
      {
        path: "#{base_path}.atom",
        type: "exact",
      }
    ]
  end

  def details
    {
      document_noun: "policy",
      email_signup_enabled: false,
      filter: {
        document_type: "policy"
      },
      show_summaries: false,
      facets: [],
    }
  end

  def publishing_api
    @publishing_api ||= PolicyPublisher.services(:publishing_api)
  end

end
