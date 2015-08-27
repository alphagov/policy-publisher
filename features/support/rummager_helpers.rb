require "gds_api/test_helpers/rummager"

module RummagerHelpers
  include GdsApi::TestHelpers::Rummager

  def stub_rummager
    stub_any_rummager_post
  end

  def assert_policy_published_to_rummager(policy)
    # The block allows the helper compares JSON objects rather
    # than a hash to JSON

    expected_json = {
      title: policy.name,
      description: policy.description,
      link: policy.base_path,
      indexable_content: "",
      organisations: [],
      public_timestamp: policy.updated_at,
      _type: "policy",
      _id: policy.base_path,
    }.as_json
    assert_rummager_posted_item(expected_json)
  end
end

World(RummagerHelpers)
