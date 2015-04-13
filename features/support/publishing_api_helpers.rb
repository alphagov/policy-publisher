require "gds_api/test_helpers/publishing_api"

module PublishingAPIHelpers
  include GdsApi::TestHelpers::PublishingApi
  def stub_publishing_api
    stub_default_publishing_api_put
  end

  def reset_remote_requests
    WebMock::RequestRegistry.instance.reset!
  end

  def assert_content_item_is_published_to_publishing_api(base_path)
    assert_publishing_api_put_item(
      base_path,
      {
        "format" => "policy",
        "rendering_app" => "finder-frontend",
        "publishing_app" => "policy-publisher",
      },
    )
  end

  def assert_content_item_is_republished_to_publishing_api(base_path)
    assert_publishing_api_put_item(
      base_path,
      {
        "format" => "policy",
        "update_type" => "minor",
        "rendering_app" => "finder-frontend",
        "publishing_app" => "policy-publisher",
      },
    )
  end
end

World(PublishingAPIHelpers)
