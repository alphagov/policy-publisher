require "rails_helper"
require 'gds_api/test_helpers/publishing_api_v2'

RSpec.describe ContentItemPublisher do
  include GdsApi::TestHelpers::PublishingApiV2

  let(:policy) { create(:policy) }
  let(:content_item_publisher) { ContentItemPublisher.new(policy, update_type: "major") }

  describe '#run! method' do
    before do
      stub_any_publishing_api_call
      content_item_publisher.run!
    end

    it "publishes a policy to Publishing API" do
      assert_publishing_api_put_content(
        policy.content_id,
        ContentItemPresenter.new(policy).exportable_attributes.as_json
      )

      assert_publishing_api_publish(
        policy.content_id,
        update_type: 'major'
      )

      assert_publishing_api_put_links(
        policy.content_id
      )
    end
  end
end
