require "rails_helper"
require 'gds_api/test_helpers/publishing_api'

RSpec.describe PlaceholderContentItemPublisher do
  include GdsApi::TestHelpers::PublishingApi

  let(:policy) { FactoryGirl.create(:policy) }
  let(:placeholder_publisher) { PlaceholderContentItemPublisher.new(policy) }

  describe '#run! method' do
    before do
      stub_default_publishing_api_put
      placeholder_publisher.run!
    end

    it "publishes a placeholder content item to Publishing API" do
      payload = PlaceholderContentItemPresenter.new(policy).exportable_attributes.as_json
      assert_publishing_api_put_item(policy.base_path, payload)
    end
  end
end
