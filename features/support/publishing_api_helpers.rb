require "gds_api/test_helpers/publishing_api"

module PublishingAPIHelpers
  include GdsApi::TestHelpers::PublishingApi
  def stub_publishing_api
    stub_default_publishing_api_put
  end

  def reset_remote_requests
    WebMock::RequestRegistry.instance.reset!
  end

  def check_content_item_is_published_to_publishing_api(base_path, times)
    assert_publishing_api_put_item(
      base_path,
      {
        "format" => "policy_area",
        "rendering_app" => "finder-frontend",
        "publishing_app" => "policy-publisher",
      },
      times,
    )
  end
end

World(PublishingAPIHelpers)
