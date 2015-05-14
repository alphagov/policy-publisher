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
      "format" => "finder",
      "content_id" => "d6582d48-df19-46b3-bf84-9157192801a6",
      "title" => "Policies",
      "description" => "",
      "public_updated_at" => public_updated_at,
      "locale" => "en",
      "update_type" => "major",
      "publishing_app" => "policy-publisher",
      "rendering_app" => "finder-frontend",
      "routes" => routes,
      "details" => details,
      "links" => {
        "organisations" => [],
        "related" => [],
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
      filter: {
        document_type: "policy"
      },
      show_summaries: false,
      facets: facets,
    }
  end

  def facets
    [
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
        filterable: true,
        allowed_values: allowed_organisation_values,
        preposition: "from",
        name: "Organisation",
      },
    ]
  end

  def publishing_api
    @publishing_api ||= PolicyPublisher.services(:publishing_api)
  end

  def allowed_organisation_values
    allowed_orgs = organiastions_used_by_policies.map do |org|
      { label: org["title"], value: org["base_path"].split('/').last }
    end
    allowed_orgs.sort_by {|org| org[:label]}
  end

  def organiastions_used_by_policies
    PolicyPublisher.services(:content_register).organisations.select do |org|
      all_organisation_content_ids.include?(org["content_id"])
    end
  end

  def all_organisation_content_ids
    @all_organisation_content_ids ||= Policy.all.map do |policy|
      policy.organisation_content_ids
    end.flatten.uniq
  end
end
