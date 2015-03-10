require "rails_helper"
require "gds_api/test_helpers/publishing_api"

RSpec.describe ContentItemPresenter do
  include GdsApi::TestHelpers::PublishingApi

  before do
    stub_default_publishing_api_put
  end

  describe "#exportable_attributes" do
    it "validates against the schema with a policy area" do
      presenter = ContentItemPresenter.new(FactoryGirl.create(:policy_area))

      assert_valid_against_schema(presenter.exportable_attributes.as_json, "policy")
    end

    it "validates against the schema with a policy programme" do
      presenter = ContentItemPresenter.new(FactoryGirl.create(:programme))

      assert_valid_against_schema(presenter.exportable_attributes.as_json, "policy")
    end
  end
end
