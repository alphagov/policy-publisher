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

    it "doesn't add nation_applicability if the policy applies to all nations" do
      policy_area = FactoryGirl.create(:policy_area)
      attributes = ContentItemPresenter.new(policy_area).exportable_attributes.as_json
      expect(attributes["details"]).not_to have_key("nation_applicability")
    end

    it "returns a list of applicable nations if there are inapplicable nations" do
      policy_area = FactoryGirl.create(
        :policy_area,
        northern_ireland: false,
        scotland: false,
        wales: false,
      )

      attributes = ContentItemPresenter.new(policy_area).exportable_attributes.as_json
      nation_applicability = attributes["details"]["nation_applicability"]
      expect(nation_applicability["applies_to"]).to eq(["england"])
      expect(nation_applicability["alternative_policies"].length).to eq(0)
    end

    it "returns a list of alternative policies for other nations if there are alternative policies" do
      policy_area = FactoryGirl.create(
        :policy_area,
        northern_ireland: false,
        northern_ireland_policy_url: "https://www.example.ni",
        scotland: false,
        scotland_policy_url: "http://www.example.scot",
        wales: false,
        wales_policy_url: "http://example.wales",
      )

      attributes = ContentItemPresenter.new(policy_area).exportable_attributes.as_json
      nation_applicability = attributes["details"]["nation_applicability"]
      expect(nation_applicability["applies_to"]).to eq(["england"])
      expect(nation_applicability["alternative_policies"].length).to eq(3)
      expect(nation_applicability["alternative_policies"].first["nation"]).to eq("northern_ireland")
      expect(nation_applicability["alternative_policies"].first["alt_policy_url"]).to eq("https://www.example.ni")
    end
  end
end
