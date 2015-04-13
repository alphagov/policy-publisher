require "rails_helper"
require 'gds_api/test_helpers/publishing_api'
require 'gds_api/test_helpers/rummager'

RSpec.describe SearchIndexer do
  include GdsApi::TestHelpers::PublishingApi
  include GdsApi::TestHelpers::Rummager

  before do
    stub_default_publishing_api_put
    stub_any_rummager_post
  end

  it "indexes a a policy with rummager" do
    policy = FactoryGirl.create(:policy)
    indexer = SearchIndexer.new(policy)

    expected_json = {
      title: policy.name,
      description: policy.description,
      link: policy.base_path,
      slug: policy.slug,
      indexable_content: "",
      organisations: [],
      last_update: policy.updated_at,
      _type: "policy",
      _id: policy.base_path,
    }.as_json

    WebMock::RequestRegistry.instance.reset!
    indexer.index!
    assert_rummager_posted_item(expected_json)
  end
end
