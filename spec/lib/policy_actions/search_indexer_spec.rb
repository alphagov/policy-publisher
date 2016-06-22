require "rails_helper"
require 'gds_api/test_helpers/rummager'
require 'gds_api/test_helpers/publishing_api_v2'

RSpec.describe SearchIndexer do
  include GdsApi::TestHelpers::Rummager
  include GdsApi::TestHelpers::PublishingApiV2

  before do
    stub_any_rummager_post
    publishing_api_has_linkables(people, document_type: "person")
    publishing_api_has_linkables(working_groups, document_type: "working_group")
  end

  let(:people) do
    [
      {
        "content_id" => SecureRandom.uuid,
        "title" => "Person 1",
        "base_path" => "/government/people/person-1",
      },
      {
        "content_id" => SecureRandom.uuid,
        "title" => "Person 2",
        "base_path" => "/government/people/person-2",
      },
    ]
  end

  let(:working_groups) do
    [
      {
        "content_id" => SecureRandom.uuid,
        "title" => "Working group 1",
        "base_path" => "/government/groups/working-group-1",
      },
      {
        "content_id" => SecureRandom.uuid,
        "title" => "Working group 2",
        "base_path" => "/government/groups/working-group-2",
      },
    ]
  end

  it "indexes a a policy with rummager" do
    policy = FactoryGirl.create(:policy,
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
