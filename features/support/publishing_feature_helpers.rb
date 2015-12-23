require_relative '../../spec/support/publishing_api_content_helpers'

Before do
  stub_content_calls_from_publishing_api
end

World(PublishingApiContentHelpers)
