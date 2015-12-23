require 'gds_api/test_helpers/publishing_api_v2'

module PublishingApiContentHelpers
  include GdsApi::TestHelpers::PublishingApiV2

  def stub_any_publishing_api_write
    stub_any_publishing_api_put_content
    stub_any_publishing_api_put_links
    stub_any_publishing_api_publish
  end

  def stub_any_publishing_api_publish
    stub_request(:post, %r{\A#{PUBLISHING_API_V2_ENDPOINT}/content/})
  end

  def stub_content_calls_from_publishing_api
    fields = %w(content_id format title base_path)
    publishing_api_has_fields_for_format("organisation", [organisation_1, organisation_2], fields)
    publishing_api_has_fields_for_format("person", [person_1, person_2], fields)
    publishing_api_has_fields_for_format("working_group", [working_group_1, working_group_2], fields)
  end

  def organisation_1
    @organisation_1 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "organisation",
      "title" => "Organisation 1",
      "base_path" => "/government/organisations/organisation-1",
    }
  end

  def organisation_2
    @organisation_2 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "organisation",
      "title" => "Organisation 2",
      "base_path" => "/government/organisations/organisation-2",
    }
  end

  def person_1
    @person_1 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "person",
      "title" => "A Person",
      "base_path" => "/government/people/a-person",
    }
  end

  def person_2
    @person_2 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "person",
      "title" => "Another Person",
      "base_path" => "/government/people/another-person",
    }
  end

  def working_group_1
    @working_group_1 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "working_group",
      "title" => "A working group",
      "base_path" => "/government/groups/a-working_group",
    }
  end

  def working_group_2
    @working_group_2 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "working_group",
      "title" => "Another working group",
      "base_path" => "/government/groups/another-working_group",
    }
  end
end
