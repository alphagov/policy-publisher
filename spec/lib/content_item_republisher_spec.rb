require "rails_helper"
require 'gds_api/test_helpers/publishing_api'
require 'gds_api/test_helpers/rummager'

RSpec.describe ContentItemRepublisher do
  include GdsApi::TestHelpers::PublishingApi
  include GdsApi::TestHelpers::Rummager

  before do
    stub_default_publishing_api_put
    stub_any_rummager_post
  end

  let!(:policy) { FactoryGirl.create(:policy) }
  let(:content_item_publisher) { ContentItemRepublisher.new(policy) }

  describe 'run! method' do
    before do
      WebMock::RequestRegistry.instance.reset!
    end

    it "publishes a policy to Publishing API" do
      content_item_publisher.run!

      assert_publishing_api_put_item(
        policy.base_path,
        ContentItemPresenter.new(policy, 'minor').exportable_attributes.as_json
      )
    end
  end
end
