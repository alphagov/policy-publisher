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

    it "includes an appropriate filter to filter by the policy slug" do
      policy = FactoryGirl.create(:policy_area)
      presenter = ContentItemPresenter.new(policy)
      filter = {
        "policies" => [policy.slug]
      }

      expect(presenter.exportable_attributes.as_json['details']["filter"]).to eq(filter)
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

    it "includes linked people with a policy area" do
      content_id = SecureRandom.uuid
      policy_area = FactoryGirl.create(:policy_area, people_content_ids: [content_id])
      attributes = ContentItemPresenter.new(policy_area).exportable_attributes.as_json

      expect(attributes["links"]["people"]).to eq([content_id])
    end
  end
end
