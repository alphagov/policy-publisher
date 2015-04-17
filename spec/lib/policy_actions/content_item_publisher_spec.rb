require "rails_helper"
require 'gds_api/test_helpers/publishing_api'

RSpec.describe ContentItemPublisher do
  include GdsApi::TestHelpers::PublishingApi

  let(:policy) { FactoryGirl.create(:policy) }
  let(:content_item_publisher) { ContentItemPublisher.new(policy) }

  describe 'run! method' do
    before do
      stub_default_publishing_api_put
      content_item_publisher.run!
    end

    it "publishes a policy to Publishing API" do
      assert_publishing_api_put_item(
        policy.base_path,
        ContentItemPresenter.new(policy).exportable_attributes.as_json
      )
    end
  end
end
