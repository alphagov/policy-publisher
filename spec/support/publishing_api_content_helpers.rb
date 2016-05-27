require 'gds_api/test_helpers/publishing_api_v2'

module PublishingApiContentHelpers
  include GdsApi::TestHelpers::PublishingApiV2

  def stub_any_publishing_api_write
    stub_any_publishing_api_put_content
    stub_any_publishing_api_patch_links
    stub_any_publishing_api_publish
  end

  def stub_any_publishing_api_publish
    stub_request(:post, %r{\A#{PUBLISHING_API_V2_ENDPOINT}/content/})
  end

  def stub_post_to_search
    stub_request(:post, "#{Plek.find("search")}/documents")
  end

  def stub_content_calls_from_publishing_api
    publishing_api_has_linkables([lead_organisation_1, lead_organisation_2], document_type: "lead_organisation")
    publishing_api_has_linkables([organisation_1, organisation_2], document_type: "organisation")
    publishing_api_has_linkables([person_1, person_2], document_type: "person")
    publishing_api_has_linkables([working_group_1, working_group_2], document_type: "working_group")
  end

  def lead_organisation_1
    @lead_organisation_1 ||= {
      "content_id" => SecureRandom.uuid,
      "title" => "Lead Organisation 1",
      "base_path" => "/government/organisations/lead-organisation-1",
    }
  end

  def lead_organisation_2
    @lead_organisation_2 ||= {
      "content_id" => SecureRandom.uuid,
      "title" => "Lead Organisation 2",
      "base_path" => "/government/organisations/lead-organisation-1",
    }
  end


  def organisation_1
    @organisation_1 ||= {
      "content_id" => SecureRandom.uuid,
      "title" => "Organisation 1",
      "base_path" => "/government/organisations/organisation-1",
    }
  end

  def organisation_2
    @organisation_2 ||= {
      "content_id" => SecureRandom.uuid,
      "title" => "Organisation 2",
      "base_path" => "/government/organisations/organisation-2",
    }
  end

  def person_1
    @person_1 ||= {
      "content_id" => SecureRandom.uuid,
      "title" => "A Person",
      "base_path" => "/government/people/a-person",
    }
  end

  def person_2
    @person_2 ||= {
      "content_id" => SecureRandom.uuid,
      "title" => "Another Person",
      "base_path" => "/government/people/another-person",
    }
  end

  def working_group_1
    @working_group_1 ||= {
      "content_id" => SecureRandom.uuid,
      "title" => "A working group",
      "base_path" => "/government/groups/a-working_group",
    }
  end

  def working_group_2
    @working_group_2 ||= {
      "content_id" => SecureRandom.uuid,
      "title" => "Another working group",
      "base_path" => "/government/groups/another-working_group",
    }
  end

  def stub_publishing_api_links(content_id, organisations: [], lead_organisations: [], people: [], working_groups: [])
    url = PUBLISHING_API_V2_ENDPOINT + "/links/" + content_id
    links = {
      links: {
        organisations: organisations,
        lead_organisations: lead_organisations,
        people: people,
        working_groups: working_groups,
        related: [],
        email_alert_signup: [
        ]
      }
    }
    stub_request(:get, url).to_return(status: 200, body: links.to_json, headers: {})
  end

  def stub_has_links(policy, links = {})
    links["email_alert_signup"] = [policy.email_alert_signup_content_id]
    response = {
      content_id: policy.content_id,
      links: links,
    }
    publishing_api_has_links(response)
  end
end
