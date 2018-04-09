require "rails_helper"

RSpec.describe LinksPresenter do
  describe "#exportable_attributes" do
    it "validates against the policy links schema" do
      presenter = LinksPresenter.new(create(:policy))

      expect(presenter.exportable_attributes).to be_valid_against_links_schema("policy")
    end

    it "includes linked organisations" do
      content_id = SecureRandom.uuid
      policy = create(:policy, organisation_content_ids: [content_id])

      attributes = LinksPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["organisations"]).to eq([content_id])
    end

    it "includes linked people" do
      content_id = SecureRandom.uuid
      policy = create(:policy, people_content_ids: [content_id])

      attributes = LinksPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["people"]).to eq([content_id])
    end

    it "includes linked working_groups" do
      content_id = SecureRandom.uuid
      policy = create(:policy, working_group_content_ids: [content_id])

      attributes = LinksPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["working_groups"]).to eq([content_id])
    end

    it "includes related policies" do
      related_policy = create(:policy)
      policy = create(:policy, related_policies: [related_policy])

      attributes = LinksPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["related"]).to eq([related_policy.content_id])
    end

    it "includes the linked email alert signup" do
      policy = create(:policy)

      attributes = LinksPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["email_alert_signup"]).to eq([policy.email_alert_signup_content_id])
    end
  end
end
