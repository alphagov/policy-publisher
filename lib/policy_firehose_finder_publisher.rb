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

  def publish
    publishing_api.put_content_item(base_path, exportable_attributes)
  end

  def exportable_attributes
    {
      format: "finder",
      content_id: "ccb6c301-2c64-4a59-88c9-0528d0ffd088",
      title: "All policy content",
      description: "",
      public_updated_at: public_updated_at,
      locale: "en",
      update_type: "major",
      publishing_app: "policy-publisher",
      rendering_app: "finder-frontend",
      routes: routes,
      details: details,
      links: {
        organisations: [],
        related: [],
        email_alert_signup: ["452903cf-de2d-4b9f-a412-a5cc06256450"],
      },
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
        policies: "_MISSING",
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
        display_as_result_metadata: true,
        filterable: true,
        allowed_values: detailed_format_allowed_values,
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
        key: "organisations",
        name: "Organisation",
        short_name: "From",
        preposition: "from",
        type: "text",
        display_as_result_metadata: true,
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
    [
      {
        label: "Announcement",
        value: "announcement",
      },
      {
        label: "Case study",
        value: "case-study",
      },
      {
        label: "Closed consultation",
        value: "closed-consultation",
      },
      {
        label: "Collection",
        value: "collection",
      },
      {
        label: "Consultation",
        value: "consultation",
      },
      {
        label: "Consultation outcome",
        value: "consultation-outcome",
      },
      {
        label: "Corporate information",
        value: "corporate-information",
      },
      {
        label: "Corporate report",
        value: "corporate-report",
      },
      {
        label: "Correspondence",
        value: "correspondence",
      },
      {
        label: "Decision",
        value: "decision",
      },
      {
        label: "Detailed guide",
        value: "detailed-guide",
      },
      {
        label: "Fatality notice",
        value: "fatality-notice",
      },
      {
        label: "FOI release",
        value: "foi-release",
      },
      {
        label: "Form",
        value: "form",
      },
      {
        label: "Government response",
        value: "government-response",
      },
      {
        label: "Guidance",
        value: "guidance",
      },
      {
        label: "Impact assessment",
        value: "impact-assessment",
      },
      {
        label: "Imported - awaiting type",
        value: "imported-awaiting-type",
      },
      {
        label: "Independent report",
        value: "independent-report",
      },
      {
        label: "International treaty",
        value: "international-treaty",
      },
      {
        label: "Map",
        value: "map",
      },
      {
        label: "News story",
        value: "news-story",
      },
      {
        label: "Notice",
        value: "notice",
      },
      {
        label: "Open consultation",
        value: "open-consultation",
      },
      {
        label: "Policy",
        value: "policy",
      },
      {
        label: "Policy paper",
        value: "policy-paper",
      },
      {
        label: "Press release",
        value: "press-release",
      },
      {
        label: "Promotional material",
        value: "promotional-material",
      },
      {
        label: "Publication",
        value: "publication",
      },
      {
        label: "Regulation",
        value: "regulation",
      },
      {
        label: "Research and analysis",
        value: "research-and-analysis",
      },
      {
        label: "Speech",
        value: "speech",
      },
      {
        label: "Statement to Parliament",
        value: "statement-to-parliament",
      },
      {
        label: "Statistical data set",
        value: "statistical-data-set",
      },
      {
        label: "Statistics",
        value: "statistics",
      },
      {
        label: "Statistics - national statistics",
        value: "statistics-national-statistics",
      },
      {
        label: "Statutory guidance",
        value: "statutory-guidance",
      },
      {
        label: "Supporting page",
        value: "supporting-page",
      },
      {
        label: "Transparency data",
        value: "transparency-data",
      },
      {
        label: "World location news article",
        value: "world-location-news-article",
      },
      {
        label: "Worldwide priority",
        value: "worldwide-priority",
      }
    ]
  end

  def publishing_api
    @publishing_api ||= PolicyPublisher.services(:publishing_api)
  end
end
