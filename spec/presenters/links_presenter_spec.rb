require "rails_helper"

RSpec.describe LinksPresenter do
  include PublishingApiContentHelpers

  describe "#exportable_attributes" do
    it "validates against the policy links schema" do
      policy = create(:policy)
      presenter = LinksPresenter.new(policy)
      stub_has_links(policy)

      expect(presenter.exportable_attributes).to be_valid_against_links_schema("policy")
    end

    it "includes linked organisations" do
      content_id = SecureRandom.uuid
      policy = create(:policy, organisation_content_ids: [content_id])
      # stub_has_links(policy.content_id, {organisation_content_ids: [content_id]})

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
      stub_has_links(policy, {related_policies: [related_policy]})

      attributes = LinksPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["related"]).to eq([related_policy.content_id])
    end

    it "includes policies" do
      sub_policy = create(:sub_policy)
      policy_area = sub_policy.parent_policies.first

      stub_has_links(sub_policy, {policy_areas: [sub_policy.parent_policies.first]})

      attributes = LinksPresenter.new(sub_policy).exportable_attributes.as_json

      expect(attributes["links"]["policy_areas"]).to eq([policy_area.content_id])
    end

    it "includes the linked email alert signup" do
      policy = create(:policy)

      stub_has_links(policy)

      attributes = LinksPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["email_alert_signup"]).to eq([policy.email_alert_signup_content_id])
    end
  end
end
