require "rails_helper"
require 'gds_api/test_helpers/rummager'
require 'gds_api/test_helpers/publishing_api_v2'

RSpec.describe SearchIndexer do
  include GdsApi::TestHelpers::Rummager
  include GdsApi::TestHelpers::PublishingApiV2

  before do
    stub_any_rummager_post

    fields = %w(content_id format title base_path)
    publishing_api_has_fields_for_format("organisation", organisations, fields)
    publishing_api_has_fields_for_format("person", people, fields)
    publishing_api_has_fields_for_format("working_group", working_groups, fields)
  end

  let(:organisations) do
    [
      {
        "content_id" => SecureRandom.uuid,
        "format" => "organisation",
        "title" => "Organisation 1",
        "base_path" => "/government/organisations/organisation-1",
      },
      {
        "content_id" => SecureRandom.uuid,
        "format" => "organisation",
        "title" => "Organisation 2",
        "base_path" => "/government/organisations/organisation-2",
      },
    ]
  end

  let(:people) do
    [
      {
        "content_id" => SecureRandom.uuid,
        "format" => "person",
        "title" => "Person 1",
        "base_path" => "/government/people/person-1",
      },
      {
        "content_id" => SecureRandom.uuid,
        "format" => "person",
        "title" => "Person 2",
        "base_path" => "/government/people/person-2",
      },
    ]
  end

  let(:working_groups) do
    [
      {
        "content_id" => SecureRandom.uuid,
        "format" => "working_group",
        "title" => "Working group 1",
        "base_path" => "/government/groups/working-group-1",
      },
      {
        "content_id" => SecureRandom.uuid,
        "format" => "working_group",
        "title" => "Working group 2",
        "base_path" => "/government/groups/working-group-2",
      },
    ]
  end

  it "indexes a a policy with rummager" do
    policy = FactoryGirl.create(:policy,
      organisation_content_ids: organisations.map {|o| o["content_id"] },
      people_content_ids: people.map {|person| person["content_id"] },
      working_group_content_ids: working_groups.map {|wg| wg["content_id"] },
    )
    indexer = SearchIndexer.new(policy)

    expected_json = {
      title: policy.name,
      description: policy.description,
      link: policy.base_path,
      slug: policy.slug,
      indexable_content: "",
      organisations: ["organisation-1", "organisation-2"],
      people: ["person-1", "person-2"],
      policy_groups: ["working-group-1", "working-group-2"],
      public_timestamp: policy.updated_at,
      _type: "policy",
      _id: policy.base_path,
    }.as_json

    indexer.run!
    assert_rummager_posted_item(expected_json)
  end
end
