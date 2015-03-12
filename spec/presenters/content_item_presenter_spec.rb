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

      assert_valid_against_schema(presenter.exportable_attributes.as_json, "policy")
    end

    it "validates against the schema with a policy programme" do
      presenter = ContentItemPresenter.new(FactoryGirl.create(:programme))

      assert_valid_against_schema(presenter.exportable_attributes.as_json, "policy")
    end

    it "includes linked organisations with a policy area" do
      content_id = SecureRandom.uuid
      policy_area = FactoryGirl.create(:policy_area, organisation_content_ids: [content_id])
      attributes = ContentItemPresenter.new(policy_area).exportable_attributes.as_json

      expect(attributes["links"]["organisations"]).to eq([content_id])
    end

    it "includes linked organisations with a policy programme" do
      content_id = SecureRandom.uuid
      programme = FactoryGirl.create(:programme, organisation_content_ids: [content_id])
      attributes = ContentItemPresenter.new(programme).exportable_attributes.as_json

      expect(attributes["links"]["organisations"]).to eq([content_id])
    end
  end
end
