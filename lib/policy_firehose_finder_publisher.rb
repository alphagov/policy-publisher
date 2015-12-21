require "gds_api/publishing_api"

# This is a utility class for publishing the finder for all content
# tagged to every policy to the publishing API. This finder lives
# at /government/policies/all.
#
# A rake task exists to (re-)publish this to Publishing API:
#
#   bundle exec rake publishing_api:publish_policies_firehose_finder
#
class PolicyFirehoseFinderPublisher
  CONTENT_ID = "ccb6c301-2c64-4a59-88c9-0528d0ffd088"

  def publish
    publishing_api.put_content(CONTENT_ID, exportable_attributes)
    publishing_api.publish(CONTENT_ID, 'major')
  end

  def exportable_attributes
    {
      base_path: base_path,
      format: "finder",
      title: "All policy content",
      phase: "alpha",
      description: "",
      public_updated_at: public_updated_at,
      locale: "en",
      publishing_app: "policy-publisher",
      rendering_app: "finder-frontend",
      routes: routes,
      details: details,
    }
  end

private

  def base_path
    "/government/policies/all"
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
      document_noun: "documents",
      filter: {},
      reject: {
        policies: ["_MISSING"],
      },
      show_summaries: false,
      facets: facets,
    }
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
        key: "policies",
        name: "Policy",
        preposition: "in policy",
        type: "text",
        display_as_result_metadata: false,
        filterable: true,
        allowed_values: policy_allowed_values,
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

  def policy_allowed_values
    Policy.all.order('name').map { |policy|
      {
        label: policy.name,
        value: policy.slug,
      }
    }
  end

  def publishing_api
    @publishing_api ||= Services.publishing_api
  end
end
