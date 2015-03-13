require "rails_helper"
require "gds_api/test_helpers/publishing_api"
require "gds_api/test_helpers/rummager"

RSpec.describe ContentItemPresenter do
  include GdsApi::TestHelpers::PublishingApi
  include GdsApi::TestHelpers::Rummager

  before do
    stub_default_publishing_api_put
    stub_any_rummager_post
  end

  describe "#exportable_attributes" do
    it "validates against the schema with a policy area" do
      presenter = ContentItemPresenter.new(FactoryGirl.create(:policy_area))

      expect(presenter.exportable_attributes.as_json).to be_valid_against_schema('policy')
    end

    it "validates against the schema with a policy programme" do
      presenter = ContentItemPresenter.new(FactoryGirl.create(:programme))

      expect(presenter.exportable_attributes.as_json).to be_valid_against_schema('policy')
    end
  end
end
