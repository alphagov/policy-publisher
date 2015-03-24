require "rails_helper"
require 'gds_api/test_helpers/publishing_api'
require 'gds_api/test_helpers/rummager'

RSpec.describe SearchIndexer do
  include GdsApi::TestHelpers::Rummager

  before do
    stub_any_rummager_post
  end

  it "indexes a a policy with rummager" do
    policy = FactoryGirl.build(:policy_area, content_id: SecureRandom.uuid)
    indexer = SearchIndexer.new(policy)

    expected_json = {
      title: policy.name,
      description: policy.description,
      link: "/government/policies/#{policy.slug}",
      indexable_content: "",
      organisations: [],
      last_update: policy.updated_at,
      _type: "policy",
      _id: "/government/policies/#{policy.slug}",
    }.as_json

    indexer.index!
    assert_rummager_posted_item(expected_json)
  end
end